# frozen_string_literal: true

require 'test_helper'

class TestSubmit < TestCase
  def test_simple_submit
    form_with(model: Post.new) do |f|
      concat f.submit
    end

    expected = '<s-button type="submit" variant="primary" name="commit" data-disable-with="Create Post" value="Create Post">Create Post</s-button>'
    assert_dom_equal expected, form_body(@rendered)
  end
end
