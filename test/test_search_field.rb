# frozen_string_literal: true

require "test_helper"

class TestSearchField < TestCase
  include ComponentExampleTest

  def test_simple_search_field
    form_with(model: Post.new) do |f|
      concat f.search_field(:query)
    end

    expected = '<s-search-field name="post[query]"></s-search-field>'
    assert_dom_equal expected, form_body(@rendered)
  end

  def test_search_field_with_placeholder
    form_with(model: Post.new) do |f|
      concat f.search_field(:query, placeholder: "Search...")
    end

    assert_includes form_body(@rendered), 'placeholder="Search..."'
  end
end
