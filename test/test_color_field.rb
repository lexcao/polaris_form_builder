# frozen_string_literal: true

require "test_helper"

class TestColorField < TestCase
  include ComponentExampleTest

  def test_simple
    form_with(model: Post.new) do |form|
      concat form.color_field(:background_color)
    end

    expected = '<s-color-field value="#000000" name="post[background_color]"></s-color-field>'
    assert_dom_equal expected, form_body(@rendered)
  end
end
