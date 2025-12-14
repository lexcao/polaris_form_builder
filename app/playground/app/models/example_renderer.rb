# frozen_string_literal: true

class ExampleRenderer
  def initialize(view_context, component)
    @view = view_context
    @component = component
  end

  def format_erb(erb)
    normalize_indent(erb)
  end

  def render_erb_for_display(erb)
    ERB::Util.html_escape(format_erb(erb))
  end

  def render_html(erb)
    return "" if erb.blank?

    sanitize(render_with_form(erb))
  end

  def render_html_for_display(erb)
    ERB::Util.html_escape(render_html(erb))
  end

  private

  def render_with_form(erb)
    content = ""
    @view.polaris_form_with(model: Preview.new, url: @view.preview_component_path(@component)) do |form|
      content = @view.render(inline: erb, locals: { form: form })
    end
    content
  end

  def sanitize(html)
    normalize_indent(strip_template_annotations(html))
  end

  def strip_template_annotations(html)
    return "" if html.blank?

    html.gsub(/<!--\s*BEGIN inline template\s*-->\s*/, "")
        .gsub(/<!--\s*END inline template\s*-->\s*/, "")
  end

  # Remove leading/trailing blank lines and strip common minimal indentation for display
  def normalize_indent(code)
    return "" if code.blank?

    lines = code.to_s.gsub("\r\n", "\n").gsub("\r", "\n").lines

    lines.shift while lines.first&.strip == ""
    lines.pop   while lines.last&.strip  == ""
    return "" if lines.empty?

    indents = lines
      .reject { |l| l.strip.empty? }
      .map    { |l| l[/^\s*/].size }

    min_indent = indents.min || 0
    lines.map { |l| l[min_indent..] || "" }.join
  end
end
