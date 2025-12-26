# frozen_string_literal: true

require "test_helper"
require_relative "base_test"

class Components::NumberFieldTest < Components::BaseTest
  setup do
    @component = "number_field"
  end

  test "renders main example" do
    component_get(@component)
    assert_response :success

    assert_component "s-number-field", name: "preview[quantity]"
    assert_submit "Save Number Field"
  end

  test "shows errors on invalid submit" do
    component_post(@component, quantity: "")
    assert_response :unprocessable_entity

    assert_component "s-number-field", error: "can't be blank"
  end

  test "redirects on valid submit" do
    component_post(@component, quantity: "5")
    assert_response :see_other

    follow_redirect!
    assert_response :success
    assert_component "s-number-field", name: "preview[quantity]"
  end
end
