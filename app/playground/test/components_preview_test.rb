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
end
