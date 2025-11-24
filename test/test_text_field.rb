# frozen_string_literal: true

require "test_helper"

class TestTextField < TestCase
  def test_simple_text_field
    form_with(model: Post.new) do |f|
      concat f.text_field(:title)
    end

    expected = "<s-text-field name=\"post[title]\"/>"

    assert_dom_equal expected, form_body(@rendered)
  end
end
