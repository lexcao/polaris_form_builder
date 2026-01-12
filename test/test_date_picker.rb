# frozen_string_literal: true

require "test_helper"

class TestDatePicker < TestCase
  include ComponentExampleTest

  def test_simple
    form_with(model: Post.new) do |form|
      concat form.date_picker(:published_at)
    end

    expected = '<s-date-picker name="post[published_at]"></s-date-picker>'
    assert_dom_equal expected, form_body(@rendered)
  end
end
