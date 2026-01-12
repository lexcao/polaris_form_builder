# frozen_string_literal: true

require "test_helper"

class TestSwitch < TestCase
  include ComponentExampleTest

  def test_simple
    form_with(model: Post.new) do |form|
      concat form.switch(:enable_feature)
    end

    expected = '<input type="hidden" name="post[enable_feature]" value="0" autocomplete="off"><s-switch name="post[enable_feature]" value="1"></s-switch>'
    assert_dom_equal expected, form_body(@rendered)
  end
end
