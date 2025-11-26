# frozen_string_literal: true

class Parser
  Property = Struct.new(:key, :type, :default, :description, keyword_init: true)
  Example = Struct.new(:name, :description, :html_code, keyword_init: true)
  Result = Struct.new(:properties, :examples, keyword_init: true)

  def initialize(markdown_content)
    @lines = markdown_content.split("\n")
    @properties = []
    @examples = []
  end

  def parse
    parse_properties
    parse_examples
    Result.new(properties: @properties, examples: @examples)
  end

  private

  def parse_properties
    in_properties = false
    current_property = nil
    description_lines = []

    @lines.each_with_index do |line, index|
      # Start parsing properties after we see the first "* propertyname" pattern after "## TextField"
      if !in_properties && line.match?(/^## TextField$/)
        in_properties = true
        next
      end

      # Stop when we hit "### TextAutocompleteField" or "## Slots"
      if in_properties && (line.match?(/^### TextAutocompleteField$/) || line.match?(/^## Slots$/))
        # Save last property before breaking
        save_property(current_property, description_lines) if current_property
        current_property = nil  # Mark as saved
        break
      end

      next unless in_properties

      # New property starts with "* " followed by property name
      if match = line.match(/^\* (.+)$/)
        # Save previous property if exists
        save_property(current_property, description_lines) if current_property

        current_property = match[1].strip
        description_lines = []
      elsif current_property
        # Accumulate lines for current property
        description_lines << line
      end
    end

    # Save last property if we haven't already
    save_property(current_property, description_lines) if current_property
  end

  def save_property(key, lines)
    return if lines.empty?

    type = nil
    default = nil
    description_parts = []
    skip_next = false

    lines.each_with_index do |line, idx|
      next if skip_next
      skip_next = false

      stripped = line.strip

      # Skip empty lines at the beginning
      next if description_parts.empty? && stripped.empty?

      # First non-empty indented line is typically the type
      if type.nil? && !stripped.empty? && line.start_with?('  ')
        type = stripped
        next
      end

      # Check for "Default: " pattern
      if stripped.match?(/^Default:/)
        default = stripped.sub(/^Default:\s*/, '')
        next
      end

      # Accumulate description
      description_parts << stripped unless stripped.empty?
    end

    @properties << Property.new(
      key: key,
      type: type,
      default: default,
      description: description_parts.join(' ')
    )
  end

  def parse_examples
    in_examples = false
    current_example = nil
    current_description = []
    current_html = []
    in_html_block = false
    capture_html = false

    @lines.each_with_index do |line, index|
      # Look for "## Examples" section
      if line.match?(/^## Examples$/)
        in_examples = true
        next
      end

      next unless in_examples

      # Example name pattern: "* #### Name"
      if match = line.match(/^\* #### (.+)$/)
        # Save previous example if exists
        save_example(current_example, current_description, current_html) if current_example

        current_example = match[1].strip
        current_description = []
        current_html = []
        in_html_block = false
        capture_html = false
        next
      end

      # Description section
      if line.match?(/^\s+##### Description$/)
        capture_html = false
        next
      end

      # HTML code block section
      if line.match?(/^\s+##### html$/)
        capture_html = true
        in_html_block = false
        next
      end

      # Code block markers
      if line.match?(/^\s+```html$/)
        in_html_block = true
        capture_html = true
        next
      elsif line.match?(/^\s+```$/) && in_html_block
        in_html_block = false
        next
      end

      # Capture content
      if current_example
        if capture_html && in_html_block
          # Remove leading spaces (typically 2-4 spaces for indentation)
          clean_line = line.sub(/^\s{2,4}/, '')
          current_html << clean_line
        elsif !capture_html && !line.match?(/^\s+##### /)
          # Capture description (skip section headers and jsx/html markers)
          stripped = line.strip
          current_description << stripped unless stripped.empty?
        end
      end
    end

    # Save last example
    save_example(current_example, current_description, current_html) if current_example
  end

  def save_example(name, description_lines, html_lines)
    return if name.nil?

    @examples << Example.new(
      name: name,
      description: description_lines.join(' '),
      html_code: html_lines.join("\n").strip
    )
  end
end

# CLI interface
if __FILE__ == $PROGRAM_NAME
  require 'json'

  if ARGV.empty?
    puts "Usage: #{$PROGRAM_NAME} <markdown_file>"
    exit 1
  end

  markdown_file = ARGV[0]
  unless File.exist?(markdown_file)
    puts "Error: File '#{markdown_file}' not found"
    exit 1
  end

  content = File.read(markdown_file)
  parser = Parser.new(content)
  result = parser.parse

  puts "=" * 80
  puts "PROPERTIES (#{result.properties.length} found)"
  puts "=" * 80
  result.properties.each do |prop|
    puts "\nKey: #{prop.key}"
    puts "Type: #{prop.type}"
    puts "Default: #{prop.default}" if prop.default
    puts "Description: #{prop.description[0..100]}..." if prop.description
  end

  puts "\n" + ("=" * 80)
  puts "EXAMPLES (#{result.examples.length} found)"
  puts "=" * 80
  result.examples.each do |example|
    puts "\nName: #{example.name}"
    puts "Description: #{example.description[0..100]}..." if example.description
    puts "HTML Code (#{example.html_code.lines.count} lines):"
    puts example.html_code[0..150] + "..." if example.html_code.length > 150
    puts example.html_code if example.html_code.length <= 150
  end
end
