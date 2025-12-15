# frozen_string_literal: true

require "test_helper"

class ComponentsPreviewTest < ActionDispatch::IntegrationTest
  test "renders checkbox example using polaris form builder" do
    get component_url("checkbox")
    assert_response :success

    assert_select "s-checkbox[label=?]", "Require a confirmation step"
    assert_select "input[type=?]", "checkbox", count: 0
  end
end

