# frozen_string_literal: true

require "test_helper"

class TestSubmit < TestCase
  def test_simple_submit
    form_with(model: Post.new) do |f|
      concat f.submit
    end

    expected = '<s-button type="submit" name="commit" value="Create Post"/>'
    assert_dom_equal expected, form_body(@rendered)
  end
end
