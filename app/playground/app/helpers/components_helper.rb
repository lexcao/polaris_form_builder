# frozen_string_literal: true

module ComponentsHelper
  SCREENSHOT_BASE_URL = "https://shopify.dev/images/templated-apis-screenshots/admin/components"

  def component_screenshot_url(component)
    screenshot_url = component.metadata&.screenshot_url
    return screenshot_url if screenshot_url.present?

    slug =
      case component.name.to_s
      when "ColorField" then "color-field"
      when "ColorPicker" then "color-picker"
      else component.name.to_s.downcase
      end
    "#{SCREENSHOT_BASE_URL}/#{slug}.png"
  end

  def example_renderer(component = @component)
    @example_renderers ||= {}
    @example_renderers[component] ||= ExampleRenderer.new(self, component)
  end
end
