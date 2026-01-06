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
end
