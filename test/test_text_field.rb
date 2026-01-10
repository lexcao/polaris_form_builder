# frozen_string_literal: true

require "test_helper"

class TestTextField < TestCase
  include ComponentExampleTest

  def test_text_field
    form_with(model: Post.new) do |form|
      concat form.text_field(:title)
    end

    expected = '<s-text-field name="post[title]"></s-text-field>'
    assert_dom_equal expected, form_body(@rendered)
  end
end
