# frozen_string_literal: true

require "test_helper"

class TextFieldTest < TestCase
  include ComponentExampleTest

  def test_text_field
    form_with(model: Post.new) do |f|
      concat f.text_field(:title)
    end

    expected = '<s-text-field type="text" name="post[title]"></s-text-field>'
    assert_dom_equal expected, form_body(@rendered)
    assert_includes form_body(@rendered), "></s-text-field>"
  end
end
