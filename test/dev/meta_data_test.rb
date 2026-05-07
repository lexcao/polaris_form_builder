# frozen_string_literal: true

require "minitest/autorun"
require_relative "../../bin/dev/meta_data"

class MetaDataTest < Minitest::Test
  def test_lists_all_form_components
    assert_equal 17, MetaData.list.size
  end

  def test_uses_canonical_web_components_markdown_urls
    markdown_urls = MetaData.list.to_h { |component| [ component.key, component.markdown_url ] }

    assert_equal "https://shopify.dev/docs/api/app-home/web-components/forms/text-field.md", markdown_urls.fetch("textfield")
    assert_equal "https://shopify.dev/docs/api/app-home/web-components/forms/text-area.md", markdown_urls.fetch("textarea")
    assert_equal "https://shopify.dev/docs/api/app-home/web-components/forms/choice-list.md", markdown_urls.fetch("choicelist")
    assert_equal "https://shopify.dev/docs/api/app-home/web-components/forms/drop-zone.md", markdown_urls.fetch("dropzone")
  end
end
