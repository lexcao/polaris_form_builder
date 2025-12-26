# frozen_string_literal: true

require "test_helper"
require_relative "base_test"

class Components::EmailFieldTest < Components::BaseTest
  setup do
    @component = "email_field"
  end

  test "renders main example" do
    component_get(@component)
    assert_response :success

    assert_component "s-email-field", name: "preview[email]"
    assert_submit "Save Email Field"
  end

  test "shows errors on invalid submit" do
    component_post(@component, email: "")
    assert_response :unprocessable_entity

    assert_component "s-email-field", error: "can't be blank"
  end

  test "redirects on valid submit" do
    component_post(@component, email: "test@example.com")
    assert_response :see_other

    follow_redirect!
    assert_response :success
    assert_component "s-email-field", name: "preview[email]"
  end
end
