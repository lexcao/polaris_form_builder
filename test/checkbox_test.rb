# frozen_string_literal: true

require "test_helper"

class CheckboxTest < TestCase
  include ComponentExampleTest

  def test_simple_check_box
    form_with(model: Post.new) do |form|
      concat form.check_box(:published)
    end

    expect = %(
      <input name="post[published]" type="hidden" value="0" autocomplete="off">
      <s-checkbox value="1" name="post[published]"></s-checkbox>
    )
    assert_dom_equal expect, form_body(@rendered)
  end

  def test_check_box_without_hidden_input
    form_with(model: Post.new) do |form|
      concat form.check_box(:published, include_hidden: false)
    end

    expect = '<s-checkbox value="1" name="post[published]"></s-checkbox>'
    assert_dom_equal expect, form_body(@rendered)
  end

  def test_checked_from_object_value
    post = Post.new
    def post.published
      "1"
    end

    form_with(model: post) do |form|
      concat form.check_box(:published)
    end

    expect = %(
      <input name="post[published]" type="hidden" value="0" autocomplete="off">
      <s-checkbox value="1" name="post[published]" checked="checked"></s-checkbox>
    )
    assert_dom_equal expect, form_body(@rendered)
  end
end
