# frozen_string_literal: true

require "test_helper"
require "ostruct"

class ComponentsHelperTest < ActionView::TestCase
  include ComponentsHelper

  test "component_screenshot_url generates lowercase slug for simple names" do
    component = OpenStruct.new(name: "Checkbox")
    url = component_screenshot_url(component)

    assert_equal "https://shopify.dev/images/templated-apis-screenshots/admin/components/checkbox.png", url
  end

  test "component_screenshot_url generates lowercase slug for camelCase names" do
    component = OpenStruct.new(name: "TextField")
    url = component_screenshot_url(component)

    # Shopify uses lowercase (not kebab-case) for most components
    assert_equal "https://shopify.dev/images/templated-apis-screenshots/admin/components/textfield.png", url
  end

  test "component_screenshot_url uses kebab-case for ColorPicker" do
    component = OpenStruct.new(name: "ColorPicker")
    url = component_screenshot_url(component)

    # ColorPicker is a special case that uses kebab-case
    assert_equal "https://shopify.dev/images/templated-apis-screenshots/admin/components/color-picker.png", url
  end

  test "component_screenshot_url uses kebab-case for ColorField" do
    component = OpenStruct.new(name: "ColorField")
    url = component_screenshot_url(component)

    # ColorField is a special case that uses kebab-case
    assert_equal "https://shopify.dev/images/templated-apis-screenshots/admin/components/color-field.png", url
  end
end
