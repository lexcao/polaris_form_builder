# frozen_string_literal: true

require "test_helper"

class TestTextArea < TestCase
  include ComponentExampleTest

  def test_simple_text_area
    form_with(model: Post.new) do |f|
      concat f.text_area(:description)
    end

    expected = '<s-text-area name="post[description]"></s-text-area>'
    assert_dom_equal expected, form_body(@rendered)
  end

  def test_text_area_with_rows
    form_with(model: Post.new) do |f|
      concat f.text_area(:description, rows: "5")
    end

    assert_includes form_body(@rendered), 'rows="5"'
  end
end
