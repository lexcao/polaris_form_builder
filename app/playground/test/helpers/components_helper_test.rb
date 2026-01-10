# frozen_string_literal: true

require "test_helper"

class ComponentsHelperTest < ActionView::TestCase
  include ComponentsHelper

  Component = Struct.new(:name)

  test "component_screenshot_url returns kebab-case for ColorField" do
    component = Component.new("ColorField")
    assert_equal(
      "https://shopify.dev/images/templated-apis-screenshots/admin/components/color-field.png",
      component_screenshot_url(component)
    )
  end

  test "component_screenshot_url returns kebab-case for ColorPicker" do
    component = Component.new("ColorPicker")
    assert_equal(
      "https://shopify.dev/images/templated-apis-screenshots/admin/components/color-picker.png",
      component_screenshot_url(component)
    )
  end

  test "component_screenshot_url returns downcased name for simple components" do
    component = Component.new("Button")
    assert_equal(
      "https://shopify.dev/images/templated-apis-screenshots/admin/components/button.png",
      component_screenshot_url(component)
    )
  end

  test "component_screenshot_url returns downcased name for TextField" do
    component = Component.new("TextField")
    assert_equal(
      "https://shopify.dev/images/templated-apis-screenshots/admin/components/textfield.png",
      component_screenshot_url(component)
    )
  end

  test "component_screenshot_url handles symbol name" do
    component = Component.new(:Button)
    assert_equal(
      "https://shopify.dev/images/templated-apis-screenshots/admin/components/button.png",
      component_screenshot_url(component)
    )
  end
end
