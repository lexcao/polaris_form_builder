# frozen_string_literal: true

require "test_helper"
require_relative "base_test"

class Components::TextAreaTest < Components::BaseTest
  setup do
    @component = "text_area"
  end

  test "renders main example" do
    component_get(@component)
    assert_response :success

    assert_component "s-text-area", name: "preview[shipping_address]"
    assert_submit "Save Text Area"
  end

  test "shows errors on invalid submit" do
    component_post(@component, shipping_address: "")
    assert_response :unprocessable_entity

    assert_component "s-text-area", error: "can't be blank"
  end

  test "redirects on valid submit" do
    component_post(@component, shipping_address: "1776 Barnes Street")
    assert_response :see_other

    follow_redirect!
    assert_response :success
    assert_component "s-text-area", name: "preview[shipping_address]"
  end
end
