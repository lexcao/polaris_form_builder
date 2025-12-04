# frozen_string_literal: true

require 'yaml'
require 'kramdown'
require 'kramdown-parser-gfm'
require 'kramdown/utils/entities'

require_relative "component"

class Parser
  def initialize(markdown_content)
    markdown_content = ensure_utf8(markdown_content)
    @metadata = Component::MetaData.new(**extract_metadata(markdown_content))
    @document = Kramdown::Document.new(markdown_content, input: 'GFM')
    @root = @document.root
  end

  def parse
    Component::Definition.new(
      metadata: @metadata,
      properties: extract_properties_for(@metadata.title),
      examples: extract_examples.prepend(extract_main_example)
    )
  end

  private

  def extract_metadata(markdown_content)
    return {} unless markdown_content.start_with?('---')

    header = markdown_content.match(/\A---\s*\n(.*?)\n---\s*\n/m)
    return {} unless header

    YAML.safe_load(header[1], aliases: true, symbolize_names: true) || {}
  rescue Psych::SyntaxError
    {}
  end

  def extract_properties_for(name)
    section_children = collect_section_children(level: 2, title: "Properties")
    section_children = collect_section_children(level: 2, title: name) if section_children.empty?

    list = find_first_list(section_children)
    return [] unless list

    list.children.map { |item| build_property(item) }.compact
  end

  def build_property(list_item)
    blocks = list_item_blocks(list_item)
    return nil if blocks.empty?

    key = block_text(blocks.shift)
    type = block_text(blocks.shift)
    default = nil
    description_parts = []

    blocks.each do |block|
      text = block_text(block)
      next if text.empty?

      if default.nil? && text.start_with?('Default:')
        default = text.sub(/^Default:\s*/, '')
        next
      end

      description_parts << text
    end

    Component::Property.new(
      key: key,
      type: type,
      default: default.to_s,
      description: description_parts.join(' ')
    )
  end

  def list_item_blocks(list_item)
    list_item.children.select { |child| block_node?(child) }
  end

  def block_node?(node)
    %i[p header ul ol codeblock blockquote table].include?(node.type)
  end

  def extract_main_example
    section_children = collect_section_children(level: 3, title: 'Examples')
    list_items = section_children.flat_map { |node| collect_list_items(node) }
    grouped = group_children_by_heading(list_items.first)

    html_code = extract_html(grouped['html'])

    Component::Example.new(
      name: "Main example",
      description: "",
      html_code: html_code
    )
  end

  def extract_examples
    section_children = collect_section_children(level: 2, title: 'Examples')
    list_items = section_children.flat_map { |node| collect_list_items(node) }

    list_items.map { |item| build_example(item) }.compact
  end

  def build_example(list_item)
    name = first_heading_in(list_item)&.then { |heading| heading_text(heading) }
    return nil unless name

    grouped = group_children_by_heading(list_item)
    description = flatten_text(grouped['Description'])
    html_code = extract_html(grouped['html'])

    Component::Example.new(
      name: name,
      description: description,
      html_code: html_code
    )
  end

  def flatten_text(nodes)
    return '' unless nodes

    nodes.map { |node| block_text(node) }.reject(&:empty?).join(' ')
  end

  def extract_html(nodes)
    return '' unless nodes

    code_block = find_code_block(nodes, 'html')
    return code_block.value.strip if code_block

    ''
  end

  def find_code_block(nodes, language)
    nodes.find do |node|
      next false unless node.type == :codeblock

      lang = node.options[:lang].to_s
      lang.empty? || lang.casecmp(language).zero?
    end
  end

  def group_children_by_heading(list_item)
    groups = Hash.new { |hash, key| hash[key] = [] }
    current_heading = nil

    list_item.children.each do |child|
      if child.type == :header
        current_heading = heading_text(child)
        next
      end

      groups[current_heading] << child if current_heading
    end

    groups
  end

  def first_heading_in(node)
    return node if node.type == :header

    node.children.each do |child|
      heading = first_heading_in(child)
      return heading if heading
    end

    nil
  end

  def collect_list_items(node)
    return [ node ] if node.type == :li

    node.children.flat_map { |child| collect_list_items(child) }
  end

  def collect_section_children(level:, title:)
    collecting = false
    children = []

    @root.children.each do |child|
      if heading?(child)
        if collecting && child.options[:level] <= level
          break
        end

        if heading?(child, level) && heading_text(child) == title
          collecting = true
          next
        end
      end

      children << child if collecting
    end

    children
  end

  def find_first_list(nodes)
    nodes.each do |node|
      list = find_list_node(node)
      return list if list
    end

    nil
  end

  def find_list_node(node)
    return node if node.type == :ul

    node.children.each do |child|
      list = find_list_node(child)
      return list if list
    end

    nil
  end

  def block_text(node)
    return node.value.rstrip if node.type == :codeblock

    text = element_to_text(node)
    text.gsub(/\s+/, ' ').strip
  end

  def element_to_text(node)
    case node.type
    when :text, :codespan, :raw_text
      node.value.to_s
    when :entity
      Kramdown::Utils::Entities.entity(node.value).char
    when :tr
      node.children.map { |child| element_to_text(child) }.join.delete_suffix(" | ")
    when :td
      node.children.map { |child| element_to_text(child) }.join << " | "
    when :smart_quote
      node.value.to_s.include?('ldquo') || node.value.to_s.include?('rdquo') ? '"' : "'"
    else
      node.children.map { |child| element_to_text(child) }.join
    end
  end

  def heading?(node, level = nil)
    node.type == :header && (level.nil? || node.options[:level] == level)
  end

  def heading_text(node)
    block_text(node)
  end

  def ensure_utf8(str)
    str = str.to_s
    return str if str.encoding == Encoding::UTF_8

    str.force_encoding("UTF-8")
       .encode("UTF-8", invalid: :replace, undef: :replace, replace: "?")
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
  puts "NAME: #{result.name}" if result.name
  if result.metadata
    puts "TITLE: #{result.metadata.title}" if result.metadata.title
    puts "DESCRIPTION: #{result.metadata.description}" if result.metadata.description
  end
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
