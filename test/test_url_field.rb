# frozen_string_literal: true

require "test_helper"

class TestURLField < TestCase
  include ComponentExampleTest

  def test_simple_url_field
    form_with(model: Post.new) do |f|
      concat f.url_field(:website)
    end

    expected = '<s-url-field name="post[website]"></s-url-field>'
    assert_dom_equal expected, form_body(@rendered)
  end

  def test_url_field_with_placeholder
    form_with(model: Post.new) do |f|
      concat f.url_field(:website, placeholder: "https://example.com")
    end

    assert_includes form_body(@rendered), 'placeholder="https://example.com"'
  end
end
