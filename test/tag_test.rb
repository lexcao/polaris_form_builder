# frozen_string_literal: true

require "test_helper"
require "rails-dom-testing"
require_relative "../lib/polaris_form_builder/tag"

class TagTest < Minitest::Test
  include Rails::Dom::Testing::Assertions

  def test_apply
    tag = PolarisFormBuilder::Tag.new("s-text-field", "input")
    result = tag.apply("<input type='text'/>")

    assert_includes result, "</s-text-field>"
    assert_dom_equal "<s-text-field type='text'></s-text-field>", result
  end

  def test_apply_with_content
    tag = PolarisFormBuilder::Tag.new("s-text-field", "input")
    actual = tag.apply("<input type='text'/>", %(<s-icon slot="accessory" interestfor="info-tooltip"></s-icon>))

    assert_includes actual, "</s-text-field>"
    assert_includes actual, "</s-icon>"

    expect = "<s-text-field type='text'><s-icon slot='accessory' interestfor='info-tooltip'></s-icon></s-text-field>"
    assert_dom_equal expect, actual
  end
end
