# frozen_string_literal: true

require "test_helper"

class TestNumberField < TestCase
  include ComponentExampleTest

  def test_simple_number_field
    form_with(model: Post.new) do |f|
      concat f.number_field(:quantity)
    end

    expected = '<s-number-field name="post[quantity]"></s-number-field>'
    assert_dom_equal expected, form_body(@rendered)
  end

  def test_number_field_with_options
    form_with(model: Post.new) do |f|
      concat f.number_field(:quantity, min: "0", max: "100", step: "5")
    end

    assert_includes form_body(@rendered), 'min="0"'
    assert_includes form_body(@rendered), 'max="100"'
    assert_includes form_body(@rendered), 'step="5"'
  end
end
