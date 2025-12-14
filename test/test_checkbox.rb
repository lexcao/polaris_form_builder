# frozen_string_literal: true

require "test_helper"

class TestCheckbox < TestCase
  include ComponentExampleTest

  def test_simple_check_box
    form_with(model: Post.new) do |form|
      concat form.check_box(:published)
    end

    body = form_body(@rendered)
    fragment = Nokogiri::HTML5::DocumentFragment.parse(body)

    assert_equal 1, fragment.css('input[type="hidden"][name="post[published]"][value="0"]').size
    assert_equal 1, fragment.css('s-checkbox[name="post[published]"][value="1"]').size
    assert_equal 0, fragment.css('s-checkbox[type="checkbox"]').size
  end

  def test_check_box_without_hidden_input
    form_with(model: Post.new) do |form|
      concat form.check_box(:published, include_hidden: false)
    end

    body = form_body(@rendered)
    fragment = Nokogiri::HTML5::DocumentFragment.parse(body)

    assert_equal 0, fragment.css('input[type="hidden"][name="post[published]"]').size
    assert_equal 1, fragment.css('s-checkbox[name="post[published]"][value="1"]').size
  end

  def test_check_box_value_option_maps_to_checked_value
    post = Post.new
    def post.published
      "yes"
    end

    form_with(model: post) do |form|
      concat form.check_box(:published, value: "yes")
    end

    body = form_body(@rendered)
    fragment = Nokogiri::HTML5::DocumentFragment.parse(body)

    assert_equal 1, fragment.css('s-checkbox[name="post[published]"][value="yes"][checked="checked"]').size
  end

  def test_checked_from_object_value
    post = Post.new
    def post.published
      "1"
    end

    form_with(model: post) do |form|
      concat form.check_box(:published)
    end

    body = form_body(@rendered)
    fragment = Nokogiri::HTML5::DocumentFragment.parse(body)
    assert_equal 1, fragment.css('s-checkbox[name="post[published]"][checked="checked"]').size
  end
end
