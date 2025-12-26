# frozen_string_literal: true

require "test_helper"
require_relative "base_test"

class Components::SearchFieldTest < Components::BaseTest
  setup do
    @component = "search_field"
  end

  test "renders main example" do
    component_get(@component)
    assert_response :success

    assert_component "s-search-field", name: "preview[search]"
    assert_submit "Save Search Field"
  end

  test "shows errors on invalid submit" do
    component_post(@component, search: "")
    assert_response :unprocessable_entity

    assert_component "s-search-field", error: "can't be blank"
  end

  test "redirects on valid submit" do
    component_post(@component, search: "polaris")
    assert_response :see_other

    follow_redirect!
    assert_response :success
    assert_component "s-search-field", name: "preview[search]"
  end
end
