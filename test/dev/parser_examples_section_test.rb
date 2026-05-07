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

  CURRENT_DOC_MARKDOWN = <<~MARKDOWN
    ---
    title: Text field
    description: Sample
    api_name: app-home
    source_url:
      html: "https://shopify.dev/docs/api/app-home/web-components/forms/text-field"
      md: "https://shopify.dev/docs/api/app-home/web-components/forms/text-field.md"
    ---

    # Text field

    ## Text\u200BField

    Configure the following properties on the text field component.

    * **icon**

      **string**

      **Default: ''**

      **required**

      Icon displayed inside the field.

    ## Examples

    ### Add a basic text field

    Add a single-line text input for collecting short-form information from merchants.

    ## html

    ```html
    <s-text-field
      label="Store name"
      value="Jaded Pixel"
    ></s-text-field>
    ```

    ### Add an icon to a text field

    Add an icon to a text field to help merchants identify its purpose.

    ## html

    ```html
    <s-text-field
      label="Search"
      icon="search"
    ></s-text-field>
    ```
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

  def test_extracts_properties_from_current_heading_format
    parser = Parser.new(CURRENT_DOC_MARKDOWN)
    result = parser.parse

    property = result.properties.find { |item| item.key == "icon" }

    refute_nil property
    assert_equal "string", property.type
    assert_equal "''", property.default
    assert_match(/Icon displayed/, property.description)
  end

  def test_extracts_examples_from_current_heading_format
    parser = Parser.new(CURRENT_DOC_MARKDOWN)
    result = parser.parse

    main = result.examples.find { |example| example.name == "Main example" }
    basic = result.examples.find { |example| example.name == "Add a basic text field" }
    icon = result.examples.find { |example| example.name == "Add an icon to a text field" }

    assert_match(/label="Store name"/, main.html_code)
    refute_nil basic
    assert_match(/single-line text input/, basic.description)
    assert_match(/label="Store name"/, basic.html_code)
    refute_nil icon
    assert_match(/icon="search"/, icon.html_code)
  end
end
