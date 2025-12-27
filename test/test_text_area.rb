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

  def test_text_area_preserves_leading_and_trailing_whitespace
    post = Post.new(description: "  text with spaces  ")

    form_with(model: post) do |f|
      concat f.text_area(:description)
    end

    # Should preserve leading and trailing spaces in value attribute
    assert_includes form_body(@rendered), 'value="  text with spaces  "'
  end

  def test_text_area_preserves_newlines
    post = Post.new(description: "line1\nline2\n\nline3")

    form_with(model: post) do |f|
      concat f.text_area(:description)
    end

    # Newlines should be preserved in value attribute
    assert_includes form_body(@rendered), "line1\nline2\n\nline3"
  end

  def test_text_area_escapes_quotes_in_value
    post = Post.new(description: 'Text with "quotes" and \'apostrophes\'')

    form_with(model: post) do |f|
      concat f.text_area(:description)
    end

    # Quotes should be escaped in HTML attribute
    assert_includes form_body(@rendered), "&quot;"
    assert_includes form_body(@rendered), "&#39;"
  end
end
