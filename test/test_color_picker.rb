# frozen_string_literal: true

require "test_helper"

class TestColorPicker < TestCase
  include ComponentExampleTest

  def test_simple
    form_with(model: Post.new) do |form|
      concat form.color_picker(:background_color)
    end

    expected = '<s-color-picker name="post[background_color]"></s-color-picker>'
    assert_dom_equal expected, form_body(@rendered)
  end
end
