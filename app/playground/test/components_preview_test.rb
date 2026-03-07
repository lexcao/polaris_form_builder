# frozen_string_literal: true

require "test_helper"

class ComponentsPreviewTest < ActionDispatch::IntegrationTest
  test "renders choice list example using polaris form builder" do
    get component_url("choicelist")
    assert_response :success

    assert_select "s-choice-list[label=?]", "Company name"
    assert_select "s-select", count: 0
  end

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

  test "preview stores numberfield value and re-renders" do
    post preview_component_url("numberfield"), params: { preview: { quantity: "5" } }
    assert_response :redirect

    follow_redirect!
    assert_response :success

    assert_select "s-number-field[value=?]", "5"
    assert_select "h3", "Result"
    assert_includes response.body, "&quot;quantity&quot;: &quot;5&quot;"
  end

  test "preview stores emailfield value and re-renders" do
    post preview_component_url("emailfield"), params: { preview: { email: "test@example.com" } }
    assert_response :redirect

    follow_redirect!
    assert_response :success

    assert_select "s-email-field[value=?]", "test@example.com"
    assert_select "h3", "Result"
    assert_includes response.body, "&quot;email&quot;: &quot;test@example.com&quot;"
  end

  test "preview stores passwordfield value and re-renders" do
    post preview_component_url("passwordfield"), params: { preview: { password: "secret123" } }
    assert_response :redirect

    follow_redirect!
    assert_response :success

    # password_field should NOT re-render password value for security (Rails default behavior)
    assert_select "s-password-field" do |elements|
      elements.each do |element|
        refute element.attribute("value")&.value&.include?("secret123"), "Password should not be rendered in HTML"
      end
    end

    # But the password should still be stored in the Result JSON
    assert_select "h3", "Result"
    assert_includes response.body, "&quot;password&quot;: &quot;secret123&quot;"
  end

  test "preview stores urlfield value and re-renders" do
    post preview_component_url("urlfield"), params: { preview: { your_website: "https://example.com" } }
    assert_response :redirect

    follow_redirect!
    assert_response :success

    assert_select "s-url-field[value=?]", "https://example.com"
    assert_select "h3", "Result"
    assert_includes response.body, "&quot;your_website&quot;: &quot;https://example.com&quot;"
  end

  test "preview stores searchfield value and re-renders" do
    post preview_component_url("searchfield"), params: { preview: { search: "polaris" } }
    assert_response :redirect

    follow_redirect!
    assert_response :success

    assert_select "s-search-field[value=?]", "polaris"
    assert_select "h3", "Result"
    assert_includes response.body, "&quot;search&quot;: &quot;polaris&quot;"
  end

  test "preview stores textarea value and re-renders" do
    post preview_component_url("textarea"), params: { preview: { shipping_address: "123 Main St" } }
    assert_response :redirect

    follow_redirect!
    assert_response :success

    # Main example has hardcoded value in JSON, so it renders that instead of preview value
    assert_select "s-text-area[value=?]", "1776 Barnes Street, Orlando, FL 32801"
    assert_select "h3", "Result"
    assert_includes response.body, "&quot;shipping_address&quot;: &quot;123 Main St&quot;"
  end

  test "preview stores select value and re-renders" do
    post preview_component_url("select"), params: { preview: { date_range: "5" } }
    assert_response :redirect

    follow_redirect!
    assert_response :success

    assert_select "s-select[value=?]", "5"
    assert_select "h3", "Result"
    assert_includes response.body, "&quot;date_range&quot;: &quot;5&quot;"
  end

  test "preview stores color field and re-renders" do
    post preview_component_url("colorfield"), params: { preview: { field: "#FF0000" } }
    assert_response :redirect

    follow_redirect!
    assert_response :success

    assert_select "s-color-field[value=?]", "#FF0000"
    assert_select "h3", "Result"
    assert_includes response.body, "&quot;field&quot;: &quot;#FF0000&quot;"
  end

  test "preview stores date field and re-renders" do
    post preview_component_url("datefield"), params: { preview: { field: "2025-09-01" } }
    assert_response :redirect

    follow_redirect!
    assert_response :success

    assert_select "s-date-field[value=?]", "2025-09-01"
    assert_select "h3", "Result"
    assert_includes response.body, "&quot;field&quot;: &quot;2025-09-01&quot;"
  end

  test "preview stores color picker and re-renders" do
    post preview_component_url("colorpicker"), params: { preview: { field: "#FF0000" } }
    assert_response :redirect

    follow_redirect!
    assert_response :success

    assert_select "s-color-picker[value=?]", "#FF0000"
    assert_select "h3", "Result"
    assert_includes response.body, "&quot;field&quot;: &quot;#FF0000&quot;"
  end

  test "preview stores money field and re-renders" do
    post preview_component_url("moneyfield"), params: { preview: { regional_price: "2.8" } }
    assert_response :redirect

    follow_redirect!
    assert_response :success

    assert_select "s-money-field[value=?]", "2.8"
    assert_select "h3", "Result"
    assert_includes response.body, "&quot;regional_price&quot;: &quot;2.8&quot;"
  end

  test "preview stores date picker value and re-renders example attributes" do
    post preview_component_url("datepicker"), params: { preview: { field: "2025-06-01--2025-06-03" } }
    assert_response :redirect

    follow_redirect!
    assert_response :success

    # Main example has a fixed value in the ERB options, so it should not be overridden.
    assert_select "s-date-picker[type=?][view=?][value=?]", "range", "2025-05", "2025-05-28--2025-05-31"
    assert_select "h3", "Result"
    assert_includes response.body, "&quot;field&quot;: &quot;2025-06-01--2025-06-03&quot;"
  end

  test "preview stores switch and re-renders" do
    post preview_component_url("switch"), params: { preview: { enable_feature: "1" } }
    assert_response :redirect

    follow_redirect!
    assert_response :success

    assert_select "s-switch[label=?][details=?][checked=?]", "Enable feature", "Ensure all criteria are met before enabling", "checked"
    assert_select "input[type=?]", "checkbox", count: 0
    assert_select "h3", "Result"
    assert_includes response.body, "&quot;enable_feature&quot;: true"
  end

  test "preview stores drop zone files and re-renders result" do
    file = fixture_file_upload(Rails.root.join("test/fixtures/files/upload.txt"), "text/plain")
    post preview_component_url("dropzone"), params: { preview: { upload: file } }
    assert_response :redirect

    follow_redirect!
    assert_response :success

    assert_select "s-drop-zone"
    assert_select "h3", "Result"
    assert_match(/&quot;upload&quot;: &quot;upload\.txt\|text\/plain\|\d+&quot;/, response.body)
  end
end
