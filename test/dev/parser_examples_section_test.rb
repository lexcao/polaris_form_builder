# frozen_string_literal: true

require "minitest/autorun"
require_relative "../../bin/dev/parser"
require_relative "../../bin/dev/component"

class ParserExamplesSectionTest < Minitest::Test
  SAMPLE_MARKDOWN = <<~MARKDOWN
    ---
    title: TextField
    description: Sample
    api_name: app-home
    source_url:
      html: "https://shopify.dev/docs/api/app-home/polaris-web-components/forms/textfield"
      md: "https://shopify.dev/docs/api/app-home/polaris-web-components/forms/textfield.md"
    ---

    # TextField

    ## TextField

    * **label**

      **string**

      Label for input.

    Examples

    ### Examples

    * #### Code

      ##### html

      ```html
      <s-text-field label="Store name"></s-text-field>
      ```

    * #### Basic usage

      ##### Description

      Demonstrates a simple text field.

      ##### html

      ```html
      <s-text-field label="Search" placeholder="Search products..."></s-text-field>
      ```
  MARKDOWN

  PROPERTY_MARKDOWN = <<~MARKDOWN
    ---
    title: ChoiceList
    description: Sample
    api_name: app-home
    source_url:
      html: "https://shopify.dev/docs/api/app-home/polaris-web-components/forms/choicelist"
      md: "https://shopify.dev/docs/api/app-home/polaris-web-components/forms/choicelist.md"
    ---

    # ChoiceList

    ## Properties

    * **labelAccessibilityVisibility**

      **"visible" | "exclusive"**

      Visibility options.
  MARKDOWN

  def test_extracts_examples_from_level3_examples_section
    parser = Parser.new(SAMPLE_MARKDOWN)
    result = parser.parse

    names = result.examples.map(&:name)

    assert_equal "Main example", names.first
    assert_includes names, "Basic usage"
    refute_includes names, "Code"
  end

  def test_normalizes_bold_wrapped_property_type
    parser = Parser.new(PROPERTY_MARKDOWN)
    result = parser.parse

    property = result.properties.find { |item| item.key == "labelAccessibilityVisibility" }

    refute_nil property
    assert_equal '"visible" | "exclusive"', property.type
  end
end
