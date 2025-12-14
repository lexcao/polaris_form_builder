# frozen_string_literal: true

require "test_helper"

class TestPolarisTag < TestCase
  def test_tag_name
    html = '<input type="text" name="user[name]" />'

    tag = PolarisFormBuilder::PolarisTag.new(html).tag_name("s-text-field").close

    assert_dom_equal '<s-text-field type="text" name="user[name]"></s-text-field>', tag.to_html
  end

  def test_exclude_attributes
    html = '<input type="text" name="user[name]" data-x="1" />'

    tag = PolarisFormBuilder::PolarisTag.new(html)
      .tag_name("s-text-field")
      .exclude_attributes("type", "data-x")
      .close

    assert_dom_equal '<s-text-field name="user[name]"></s-text-field>', tag.to_html
  end

  def test_content_inserts_children
    html = '<input type="text" name="user[name]" />'

    tag = PolarisFormBuilder::PolarisTag.new(html)
      .tag_name("s-text-field")
      .content("<s-icon></s-icon>")
      .close

    assert_dom_equal '<s-text-field type="text" name="user[name]"><s-icon></s-icon></s-text-field>', tag.to_html
  end

  def test_close_adds_close_tag_for_void_input
    html = '<input type="text" name="user[name]" />'

    tag = PolarisFormBuilder::PolarisTag.new(html).tag_name("s-text-field").close

    assert_includes tag.to_html, "</s-text-field>"
  end

  def test_builder_is_lazy_until_to_html
    html = '<input type="text" name="user[name]" />'

    tag = PolarisFormBuilder::PolarisTag.new(html)
      .tag_name("s-text-field")
      .exclude_attributes("type")
      .content("X")
      .close

    assert_equal html, html
    assert_dom_equal '<s-text-field name="user[name]">X</s-text-field>', tag.to_html
  end
end
