# frozen_string_literal: true

require "test_helper"

class TestDropZone < TestCase
  include ComponentExampleTest

  def test_simple
    form_with(model: Post.new) do |form|
      concat form.drop_zone(:upload)
    end

    expected = '<s-drop-zone name="post[upload]"></s-drop-zone>'
    assert_dom_equal expected, form_body(@rendered)
  end
end
