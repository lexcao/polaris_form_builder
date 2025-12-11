# frozen_string_literal: true

require "test_helper"
require_relative "base_test"

class Components::TextFieldTest < Components::BaseTest
  setup do
    @component = "text_field"
  end

  test "renders main example" do
    component_get(@component)
    assert_response :success

    assert_component "s-text-field", name: "preview[store_name]", label: "Store name", value: "Jaded Pixel"
    assert_submit "Save Text Field"
  end

  test "shows errors on invalid submit" do
    component_post(@component, store_name: "")
    assert_response :unprocessable_entity

    assert_component "s-text-field", error: "can't be blank"
  end

  test "redirects on valid submit" do
    component_post(@component, store_name: "Acme")
    assert_response :see_other

    follow_redirect!
    assert_response :success
    assert_component "s-text-field", name: "preview[store_name]", value: "Acme"
  end
end
