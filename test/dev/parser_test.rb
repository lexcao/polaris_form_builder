# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../../bin/dev/parser'
require_relative '../../bin/dev/component'

class ParserTest < Minitest::Test
  def setup
    @markdown_file = File.join(__dir__, '../../bin/dev/text_filed.md')
    @content = File.read(@markdown_file)
    @parser = Parser.new(@content)
    @result = @parser.parse
  end

  def test_parser_returns_parse_result
    assert_instance_of Component::Definition, @result
    assert_respond_to @result, :metadata
    assert_respond_to @result, :properties
    assert_respond_to @result, :examples
  end

  def test_metadata_and_name_are_extracted
    assert_instance_of Component::MetaData, @result.metadata
    assert_equal 'TextField', @result.metadata.title
  end

  def test_properties_are_extracted
    refute_empty @result.properties, 'Properties should not be empty'
    assert_operator @result.properties.length, :>, 10, 'Should extract more than 10 properties'
  end

  def test_property_structure
    property = @result.properties.first
    assert_instance_of Component::Property, property
    assert_respond_to property, :key
    assert_respond_to property, :type
    assert_respond_to property, :default
    assert_respond_to property, :description
  end

  def test_autocomplete_property
    autocomplete = @result.properties.find { |p| p.key == 'autocomplete' }

    refute_nil autocomplete, 'autocomplete property should exist'
    assert_equal 'autocomplete', autocomplete.key
    # assert_equal '"on" | "off" | TextAutocompleteField | \\`section-${string} one-time-code\\` | "shipping one-time-code" | "billing one-time-code" | \\`section-${string} shipping one-time-code\\` | \\`section-${string} billing one-time-code\\` | \\`section-${string} language\\` | \\`section-${string} organization\\` | \\`section-${string} additional-name\\` | \\`section-${string} address-level1\\` | \\`section-${string} address-level2\\` | \\`section-${string} address-level3\\` | \\`section-${string} address-level4\\` | \\`section-${string} address-line1\\` | \\`section-${string} address-line2\\` | \\`section-${string} address-line3\\` | \\`section-${string} country-name\\` | \\`section-${string} country\\` | \\`section-${string} family-name\\` | \\`section-${string} given-name\\` | \\`section-${string} honorific-prefix\\` | \\`section-${string} honorific-suffix\\` | \\`section-${string} name\\` | \\`section-${string} nickname\\` | \\`section-${string} organization-title\\` | \\`section-${string} postal-code\\` | \\`section-${string} sex\\` | \\`section-${string} street-address\\` | \\`section-${string} transaction-currency\\` | \\`section-${string} username\\` | \\`section-${string} cc-additional-name\\` | \\`section-${string} cc-family-name\\` | \\`section-${string} cc-given-name\\` | \\`section-${string} cc-name\\` | \\`section-${string} cc-type\\` | "shipping language" | "shipping organization" | "shipping additional-name" | "shipping address-level1" | "shipping address-level2" | "shipping address-level3" | "shipping address-level4" | "shipping address-line1" | "shipping address-line2" | "shipping address-line3" | "shipping country-name" | "shipping country" | "shipping family-name" | "shipping given-name" | "shipping honorific-prefix" | "shipping honorific-suffix" | "shipping name" | "shipping nickname" | "shipping organization-title" | "shipping postal-code" | "shipping sex" | "shipping street-address" | "shipping transaction-currency" | "shipping username" | "shipping cc-additional-name" | "shipping cc-family-name" | "shipping cc-given-name" | "shipping cc-name" | "shipping cc-type" | "billing language" | "billing organization" | "billing additional-name" | "billing address-level1" | "billing address-level2" | "billing address-level3" | "billing address-level4" | "billing address-line1" | "billing address-line2" | "billing address-line3" | "billing country-name" | "billing country" | "billing family-name" | "billing given-name" | "billing honorific-prefix" | "billing honorific-suffix" | "billing name" | "billing nickname" | "billing organization-title" | "billing postal-code" | "billing sex" | "billing street-address" | "billing transaction-currency" | "billing username" | "billing cc-additional-name" | "billing cc-family-name" | "billing cc-given-name" | "billing cc-name" | "billing cc-type" | \\`section-${string} shipping language\\` | \\`section-${string} shipping organization\\` | \\`section-${string} shipping additional-name\\` | \\`section-${string} shipping address-level1\\` | \\`section-${string} shipping address-level2\\` | \\`section-${string} shipping address-level3\\` | \\`section-${string} shipping address-level4\\` | \\`section-${string} shipping address-line1\\` | \\`section-${string} shipping address-line2\\` | \\`section-${string} shipping address-line3\\` | \\`section-${string} shipping country-name\\` | \\`section-${string} shipping country\\` | \\`section-${string} shipping family-name\\` | \\`section-${string} shipping given-name\\` | \\`section-${string} shipping honorific-prefix\\` | \\`section-${string} shipping honorific-suffix\\` | \\`section-${string} shipping name\\` | \\`section-${string} shipping nickname\\` | \\`section-${string} shipping organization-title\\` | \\`section-${string} shipping postal-code\\` | \\`section-${string} shipping sex\\` | \\`section-${string} shipping street-address\\` | \\`section-${string} shipping transaction-currency\\` | \\`section-${string} shipping username\\` | \\`section-${string} shipping cc-additional-name\\` | \\`section-${string} shipping cc-family-name\\` | \\`section-${string} shipping cc-given-name\\` | \\`section-${string} shipping cc-name\\` | \\`section-${string} shipping cc-type\\` | \\`section-${string} billing language\\` | \\`section-${string} billing organization\\` | \\`section-${string} billing additional-name\\` | \\`section-${string} billing address-level1\\` | \\`section-${string} billing address-level2\\` | \\`section-${string} billing address-level3\\` | \\`section-${string} billing address-level4\\` | \\`section-${string} billing address-line1\\` | \\`section-${string} billing address-line2\\` | \\`section-${string} billing address-line3\\` | \\`section-${string} billing country-name\\` | \\`section-${string} billing country\\` | \\`section-${string} billing family-name\\` | \\`section-${string} billing given-name\\` | \\`section-${string} billing honorific-prefix\\` | \\`section-${string} billing honorific-suffix\\` | \\`section-${string} billing name\\` | \\`section-${string} billing nickname\\` | \\`section-${string} billing organization-title\\` | \\`section-${string} billing postal-code\\` | \\`section-${string} billing sex\\` | \\`section-${string} billing street-address\\` | \\`section-${string} billing transaction-currency\\` | \\`section-${string} billing username\\` | \\`section-${string} billing cc-additional-name\\` | \\`section-${string} billing cc-family-name\\` | \\`section-${string} billing cc-given-name\\` | \\`section-${string} billing cc-name\\` | \\`section-${string} billing cc-type\\`', autocomplete.type
    assert_match(/A hint as to the intended content/, autocomplete.description)
  end

  def test_disabled_property
    disabled = @result.properties.find { |p| p.key == 'disabled' }

    refute_nil disabled, 'disabled property should exist'
    assert_equal 'disabled', disabled.key
    assert_equal 'boolean', disabled.type
    assert_equal 'false', disabled.default
    assert_match(/Disables the field/, disabled.description)
  end

  def test_label_property
    label = @result.properties.find { |p| p.key == 'label' }

    refute_nil label, 'label property should exist'
    assert_equal 'label', label.key
    assert_equal 'string', label.type
    assert_match(/Content to use as the field label/, label.description)
  end

  def test_max_length_property
    max_length = @result.properties.find { |p| p.key == 'maxLength' }

    refute_nil max_length, 'maxLength property should exist'
    assert_equal 'maxLength', max_length.key
    assert_equal 'number', max_length.type
    assert_equal 'Infinity', max_length.default
    assert_match(/maximum number of characters/, max_length.description)
  end

  def test_placeholder_property
    placeholder = @result.properties.find { |p| p.key == 'placeholder' }

    refute_nil placeholder, 'placeholder property should exist'
    assert_equal 'placeholder', placeholder.key
    assert_equal 'string', placeholder.type
    assert_match(/short hint that describes/, placeholder.description)
  end

  def test_required_property
    required = @result.properties.find { |p| p.key == 'required' }

    refute_nil required, 'required property should exist'
    assert_equal 'required', required.key
    assert_equal 'boolean', required.type
    assert_equal 'false', required.default
  end

  def test_examples_are_extracted
    refute_empty @result.examples, 'Examples should not be empty'
    assert_operator @result.examples.length, :>=, 5, 'Should extract at least 5 examples'
  end

  def test_example_structure
    example = @result.examples.first
    assert_instance_of Component::Example, example
    assert_respond_to example, :name
    assert_respond_to example, :description
    assert_respond_to example, :html_code
  end

  def test_basic_usage_example
    basic = @result.examples.find { |e| e.name == 'Basic usage' }

    refute_nil basic, 'Basic usage example should exist'
    assert_equal 'Basic usage', basic.name
    assert_match(/simple text input field/, basic.description)
    assert_match(/<s-text-field/, basic.html_code)
    assert_match(/label="Store name"/, basic.html_code)
    assert_match(/autocomplete="off"/, basic.html_code)
  end

  def test_with_icon_example
    with_icon = @result.examples.find { |e| e.name == 'With icon' }

    refute_nil with_icon, 'With icon example should exist'
    assert_equal 'With icon', with_icon.name
    assert_match(/search icon/, with_icon.description)
    assert_match(/<s-text-field/, with_icon.html_code)
    assert_match(/icon="search"/, with_icon.html_code)
  end

  def test_required_field_example
    required_field = @result.examples.find { |e| e.name == 'Required field with validation' }

    refute_nil required_field, 'Required field example should exist'
    assert_equal 'Required field with validation', required_field.name
    assert_match(/marked as required/, required_field.description)
    assert_match(/required/, required_field.html_code)
  end

  def test_prefix_suffix_example
    prefix_suffix = @result.examples.find { |e| e.name == 'With prefix and suffix' }

    refute_nil prefix_suffix, 'With prefix and suffix example should exist'
    assert_match(/prefix and suffix/, prefix_suffix.description)
    assert_match(/prefix=/, prefix_suffix.html_code)
    assert_match(/suffix=/, prefix_suffix.html_code)
  end

  def test_with_accessory_example
    accessory = @result.examples.find { |e| e.name == 'With accessory' }

    refute_nil accessory, 'With accessory example should exist'
    assert_match(/interactive elements/, accessory.description)
    assert_match(/<s-icon/, accessory.html_code)
    assert_match(/slot="accessory"/, accessory.html_code)
  end

  def test_html_code_is_clean
    @result.examples.each do |example|
      # Should not contain markdown backticks
      refute_match(/```/, example.html_code, 'HTML code should not contain markdown backticks')

      # Should contain actual HTML tags if not empty
      assert_match(/</, example.html_code, 'HTML code should contain HTML tags') if example.html_code.length.positive?
    end
  end

  def test_all_property_keys_are_unique
    keys = @result.properties.map(&:key)
    assert_equal keys.uniq.length, keys.length, 'All property keys should be unique'
  end

  def test_all_example_names_are_unique
    names = @result.examples.map(&:name)
    assert_equal names.uniq.length, names.length, 'All example names should be unique'
  end

  def test_properties_with_defaults
    properties_with_defaults = @result.properties.select(&:default)

    assert_operator properties_with_defaults.length, :>, 5, 'Should have multiple properties with defaults'

    # Check specific defaults
    icon_prop = @result.properties.find { |p| p.key == 'icon' }
    assert_equal "''", icon_prop.default if icon_prop

    readonly_prop = @result.properties.find { |p| p.key == 'readOnly' }
    assert_equal 'false', readonly_prop.default if readonly_prop
  end
end
