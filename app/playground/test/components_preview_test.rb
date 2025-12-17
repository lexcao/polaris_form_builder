# frozen_string_literal: true

require "test_helper"

class ComponentsPreviewTest < ActionDispatch::IntegrationTest
  test "renders checkbox example using polaris form builder" do
    get component_url("checkbox")
    assert_response :success

    assert_select "s-checkbox[label=?]", "Require a confirmation step"
    assert_select "input[type=?]", "checkbox", count: 0
  end

  test "preview stores checkbox value and re-renders checked state" do
    post preview_component_url("checkbox"), params: { preview: { require_a_confirmation_step: "1" } }
    assert_response :redirect

    follow_redirect!
    assert_response :success

    assert_select "s-checkbox[label=?][checked=?]", "Require a confirmation step", "checked"
    assert_select "h3", "Result"
    assert_includes response.body, "&quot;require_a_confirmation_step&quot;: true"
  end

  test "renders text area example using polaris form builder" do
    get component_url("textarea")
    assert_response :success

    assert_select(
      "s-text-area[name=?][label=?][value=?][rows=?]",
      "preview[shipping_address]",
      "Shipping address",
      "1776 Barnes Street, Orlando, FL 32801",
      "3"
    )
    assert_select "textarea", count: 0
  end

  test "preview stores text area value and renders Result JSON" do
    post preview_component_url("textarea"), params: { preview: { shipping_address: "ACME Street" } }
    assert_response :redirect

    follow_redirect!
    assert_response :success

    assert_select "h3", "Result"
    assert_includes response.body, "&quot;shipping_address&quot;: &quot;ACME Street&quot;"
  end
end
