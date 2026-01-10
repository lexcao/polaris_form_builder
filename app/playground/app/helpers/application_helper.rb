# frozen_string_literal: true

module ApplicationHelper
  def example_renderer(component = @component)
    @example_renderers ||= {}
    @example_renderers[component] ||= ExampleRenderer.new(self, component)
  end
end
