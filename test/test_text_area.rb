# frozen_string_literal: true

require "test_helper"

class TestTextArea < TestCase
  include ComponentExampleTest

  def test_simple_text_area_renders_single_component_tag
    form_with(model: Post.new) do |form|
      concat form.text_area(:title)
    end

    body = form_body(@rendered)
    fragment = Nokogiri::HTML5::DocumentFragment.parse(body)

    assert_equal 1, fragment.css('s-text-area[name="post[title]"]').size
    assert_equal 0, fragment.css("textarea").size
  end

  def test_text_area_moves_value_to_attribute
    post = Post.new
    def post.title
      %(Hello "world")
    end

    form_with(model: post) do |form|
      concat form.text_area(:title)
    end

    body = form_body(@rendered)
    fragment = Nokogiri::HTML5::DocumentFragment.parse(body)

    element = fragment.at_css("s-text-area")
    assert_equal %(Hello "world"), element["value"]
    assert_equal "", element.text
  end

  def test_text_area_maps_minlength_to_min_length_property
    form_with(model: Post.new) do |form|
      concat form.text_area(:title, minlength: "20")
    end

    body = form_body(@rendered)
    assert_includes body, 'minLength="20"'
    refute_match(/\sminlength=/, body)
  end

  def test_text_area_does_not_render_default_cols_or_rows
    form_with(model: Post.new) do |form|
      concat form.text_area(:title)
    end

    body = form_body(@rendered)
    fragment = Nokogiri::HTML5::DocumentFragment.parse(body)

    assert_equal 0, fragment.css("s-text-area[cols]").size
    assert_equal 0, fragment.css("s-text-area[rows]").size
  end
end
