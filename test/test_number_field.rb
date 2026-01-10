# frozen_string_literal: true

require "test_helper"

class TestNumberField < TestCase
  include ComponentExampleTest

  def test_simple_number_field
    form_with(model: Post.new) do |form|
      concat form.number_field(:quantity)
    end

    expected = '<s-number-field name="post[quantity]"></s-number-field>'
    assert_dom_equal expected, form_body(@rendered)
  end

  def test_number_field_with_options
    form_with(model: Post.new) do |form|
      concat form.number_field(:quantity, min: "0", max: "100", step: "5")
    end

    rendered = form_body(@rendered)
    assert_includes rendered, 'min="0"'
    assert_includes rendered, 'max="100"'
    assert_includes rendered, 'step="5"'
  end

  def test_number_field_with_in_option
    form_with(model: Post.new) do |form|
      concat form.number_field(:quantity, in: 1..100)
    end

    rendered = form_body(@rendered)
    assert_includes rendered, 'min="1"'
    assert_includes rendered, 'max="100"'
  end

  def test_number_field_with_within_option
    form_with(model: Post.new) do |form|
      concat form.number_field(:quantity, within: 5..20)
    end

    rendered = form_body(@rendered)
    assert_includes rendered, 'min="5"'
    assert_includes rendered, 'max="20"'
  end
end
