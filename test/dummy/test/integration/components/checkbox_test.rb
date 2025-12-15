# frozen_string_literal: true

require "test_helper"
require_relative "base_test"

class Components::CheckboxTest < Components::BaseTest
  setup do
    @component = "checkbox"
  end

  test "renders main example" do
    component_get(@component)
    assert_response :success

    assert_component(
      "s-checkbox",
      name: "preview[require_a_confirmation_step]",
      label: "Require a confirmation step",
      details: "Ensure all criteria are met before proceeding"
    )
    assert_submit "Save Checkbox"
  end

  test "shows errors on invalid submit" do
    component_post(@component, require_a_confirmation_step: "0")
    assert_response :unprocessable_entity

    assert_component "s-checkbox", error: "must be accepted"
  end

  test "redirects on valid submit" do
    component_post(@component, require_a_confirmation_step: "1")
    assert_response :see_other

    follow_redirect!
    assert_response :success
    assert_component "s-checkbox", name: "preview[require_a_confirmation_step]", checked: "checked"
  end
end
