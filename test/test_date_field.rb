# frozen_string_literal: true

require "test_helper"

class TestDateField < TestCase
  include ComponentExampleTest

  def test_simple
    form_with(model: Post.new) do |form|
      concat form.date_field(:published_at)
    end

    expected = '<s-date-field name="post[published_at]"></s-date-field>'
    assert_dom_equal expected, form_body(@rendered)
  end
end
