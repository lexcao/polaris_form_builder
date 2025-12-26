# frozen_string_literal: true

require "test_helper"
require_relative "base_test"

class Components::PasswordFieldTest < Components::BaseTest
  setup do
    @component = "password_field"
  end

  test "renders main example" do
    component_get(@component)
    assert_response :success

    assert_component "s-password-field", name: "preview[password]"
    assert_submit "Save Password Field"
  end

  test "shows errors on invalid submit" do
    component_post(@component, password: "")
    assert_response :unprocessable_entity

    assert_component "s-password-field", error: "can't be blank"
  end

  test "redirects on valid submit" do
    component_post(@component, password: "secret123")
    assert_response :see_other

    follow_redirect!
    assert_response :success
    assert_component "s-password-field", name: "preview[password]"
  end
end
