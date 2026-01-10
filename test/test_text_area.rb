# frozen_string_literal: true

require "test_helper"

class TestTextArea < TestCase
  include ComponentExampleTest

  def test_simple_text_area
    form_with(model: Post.new(description: "This is the description")) do |form|
      concat form.text_area(:description)
    end

    expected = '<s-text-area name="post[description]" value="This is the description"></s-text-area>'
    assert_dom_equal expected, form_body(@rendered)
  end
end
