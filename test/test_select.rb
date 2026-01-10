# frozen_string_literal: true

require "test_helper"

class TestSelect < TestCase
  include ComponentExampleTest

  def test_simple_choices
    form_with(model: Post.new) do |form|
      concat form.select(:category, %w[Ruby Rails])
    end

    expected = %(
      <s-select name="post[category]">
        <s-option value="Ruby">Ruby</s-option>
        <s-option value="Rails">Rails</s-option>
      </s-select>
    )
    assert_dom_equal expected, form_body(@rendered)
  end

  def test_nested_choices
    form_with(model: Post.new) do |form|
      concat(form.select(:category, [], {}, { label: "Category" }) do
        concat content_tag("s-option", "Ruby", value: "Ruby")
        concat content_tag("s-option", "Rails", value: "Rails")
      end)
    end

    expected = %(
      <s-select name="post[category]" label="Category">
        <s-option value="Ruby">Ruby</s-option>
        <s-option value="Rails">Rails</s-option>
      </s-select>
    )
    assert_dom_equal expected, form_body(@rendered)
  end

  def test_selected
    form_with(model: Post.new) do |form|
      concat form.select(:category, %w[Ruby Rails], { selected: "Rails" })
    end

    expected = %(
      <s-select name="post[category]">
        <s-option value="Ruby">Ruby</s-option>
        <s-option selected="selected" value="Rails">Rails</s-option>
      </s-select>
    )
    assert_dom_equal expected, form_body(@rendered)
  end

  def test_selected_by_value
    form_with(model: Post.new(category: "Ruby")) do |form|
      concat form.select(:category, %w[Ruby Rails])
    end

    expected = %(
      <s-select name="post[category]" value="Ruby">
        <s-option selected="selected" value="Ruby">Ruby</s-option>
        <s-option value="Rails">Rails</s-option>
      </s-select>
    )
    assert_dom_equal expected, form_body(@rendered)
  end
end
