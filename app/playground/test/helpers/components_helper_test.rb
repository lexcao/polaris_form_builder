# frozen_string_literal: true

require "test_helper"

class ComponentsHelperTest < ActionView::TestCase
  include ComponentsHelper

  Metadata = Struct.new(:screenshot_url)
  Component = Struct.new(:name, :metadata)

  test "component_screenshot_url returns metadata screenshot when present" do
    component = Component.new("Checkbox", Metadata.new("https://cdn.shopify.com/example/checkbox-hash.png"))

    assert_equal(
      "https://cdn.shopify.com/example/checkbox-hash.png",
      component_screenshot_url(component)
    )
  end

  test "component_screenshot_url returns kebab-case for ColorField" do
    component = Component.new("ColorField", nil)
    assert_equal(
      "https://shopify.dev/images/templated-apis-screenshots/admin/components/color-field.png",
      component_screenshot_url(component)
    )
  end

  test "component_screenshot_url returns kebab-case for ColorPicker" do
    component = Component.new("ColorPicker", nil)
    assert_equal(
      "https://shopify.dev/images/templated-apis-screenshots/admin/components/color-picker.png",
      component_screenshot_url(component)
    )
  end

  test "component_screenshot_url returns downcased name for simple components" do
    component = Component.new("Button", nil)
    assert_equal(
      "https://shopify.dev/images/templated-apis-screenshots/admin/components/button.png",
      component_screenshot_url(component)
    )
  end

  test "component_screenshot_url returns downcased name for TextField" do
    component = Component.new("TextField", nil)
    assert_equal(
      "https://shopify.dev/images/templated-apis-screenshots/admin/components/textfield.png",
      component_screenshot_url(component)
    )
  end

  test "component_screenshot_url handles symbol name" do
    component = Component.new(:Button, nil)
    assert_equal(
      "https://shopify.dev/images/templated-apis-screenshots/admin/components/button.png",
      component_screenshot_url(component)
    )
  end
end
