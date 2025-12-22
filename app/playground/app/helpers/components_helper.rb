module ComponentsHelper
  def component_screenshot_url(component)
    slug =
      case component.name.to_s
      when "ColorField" then "color-field"
      when "ColorPicker" then "color-picker"
      else component.name.to_s.downcase
      end
    "https://shopify.dev/images/templated-apis-screenshots/admin/components/#{slug}.png"
  end
end
