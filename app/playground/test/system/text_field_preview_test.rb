# frozen_string_literal: true

require "application_system_test_case"

class TextFieldPreviewTest < ApplicationSystemTestCase
  test "preview submits and renders Result for TextField" do
    visit component_path("textfield")

    assert_selector "h3", text: "Preview"
    assert_selector "s-text-field[name='preview[store_name]']", visible: :all
    assert_selector "form[action$='/preview']", visible: :all

    fill_in_preview_text_field(name: "preview[store_name]", with: "ACME Store")
    submit_preview

    assert_selector "h3", text: "Result"
    assert_text "\"store_name\": \"ACME Store\""

    visit current_path
    assert_no_selector "h3", text: "Result"
  end

  private
    def fill_in_preview_text_field(name:, with:)
      host = preview_form.find("s-text-field[name='#{name}']", match: :first, visible: :all)

      within(host.shadow_root) do
        input = find("input, textarea", visible: :all)
        input.click
        input.send_keys([ :command, "a" ], :backspace)
        input.send_keys([ :control, "a" ], :backspace)
        input.send_keys(with)
      end
    end

    def submit_preview
      host = preview_form.find("s-button", text: "Try it", exact_text: true)

      within(host.shadow_root) do
        find("button, input[type='submit']", visible: :all).send_keys(:enter)
      end
    end

    def preview_form
      find("s-button", text: "Try it", exact_text: true).ancestor("form", visible: :all)
    end
end
