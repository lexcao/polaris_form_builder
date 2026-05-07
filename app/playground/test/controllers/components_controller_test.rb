# frozen_string_literal: true

require "test_helper"

class ComponentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get components_url
    assert_response :success
  end

  test "should find components by compact legacy param" do
    get component_url("numberfield")
    assert_response :success

    assert_select "s-number-field"
  end

  test "should find components by hyphenated legacy param" do
    get component_url("number-field")
    assert_response :success

    assert_select "s-number-field"
  end

  test "drop zone preview form is multipart" do
    get component_url("dropzone")
    assert_response :success

    assert_select "form[enctype=?]", "multipart/form-data"
  end
end
