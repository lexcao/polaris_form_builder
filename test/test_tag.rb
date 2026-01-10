# frozen_string_literal: true

require "test_helper"

class TestTag < Minitest::Test
  include Rails::Dom::Testing::Assertions

  def test_apply
    tag = PolarisFormBuilder::Tag.new("s-text-field", "input")
    result = tag.apply("<input type='text'/>")

    assert_dom_equal "<s-text-field type='text'></s-text-field>", result
  end

  def test_apply_with_content
    tag = PolarisFormBuilder::Tag.new("s-text-field", "input")
    actual = tag.apply("<input type='text'/>", %(<s-icon slot="accessory" interestfor="info-tooltip"></s-icon>))

    expected = "<s-text-field type='text'><s-icon slot='accessory' interestfor='info-tooltip'></s-icon></s-text-field>"
    assert_dom_equal expected, actual
  end

  def test_apply_with_attr
    tag = PolarisFormBuilder::Tag.new("s-text-field", "input")
                                 .attr("value", "test")

    actual = tag.apply("<input type='text'/>")

    expected = "<s-text-field type='text' value='test'></s-text-field>"
    assert_dom_equal expected, actual
  end

  def test_apply_attr_to_child
    tag = PolarisFormBuilder::Tag.new("s-button", "input")
                                 .attr_to_child("value")

    actual = tag.apply("<input type='submit' value='Submit'/>")

    expected = "<s-button type='submit' value='Submit'>Submit</s-button>"
    assert_dom_equal expected, actual
  end

  def test_apply_child_to_attr
    tag = PolarisFormBuilder::Tag.new("s-text-area", "textarea")
                                 .child_to_attr("value")

    given = <<~HTML
      <textarea>Ruby on Rails
      Shopify Polaris Web Components</textarea>
    HTML

    actual = tag.apply(given)

    expected = "<s-text-area value='Ruby on Rails\nShopify Polaris Web Components'></s-text-area>"
    assert_dom_equal expected, actual
  end
end
