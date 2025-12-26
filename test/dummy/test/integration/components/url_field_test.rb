# frozen_string_literal: true

require "test_helper"
require_relative "base_test"

class Components::URLFieldTest < Components::BaseTest
  setup do
    @component = "url_field"
  end

  test "renders main example" do
    component_get(@component)
    assert_response :success

    assert_component "s-url-field", name: "preview[your_website]"
    assert_submit "Save Url Field"
  end

  test "shows errors on invalid submit" do
    component_post(@component, your_website: "")
    assert_response :unprocessable_entity

    assert_component "s-url-field", error: "can't be blank"
  end

  test "redirects on valid submit" do
    component_post(@component, your_website: "https://example.com")
    assert_response :see_other

    follow_redirect!
    assert_response :success
    assert_component "s-url-field", name: "preview[your_website]"
  end
end
