# frozen_string_literal: true

require "minitest/autorun"
require_relative "../../bin/dev/parser"
require_relative "../../bin/dev/component"

class ParserEdgeCasesTest < Minitest::Test
  def markdown(frontmatter_extra: "", key: "**maxLength**", type: "**number**")
    <<~MARKDOWN
      ---
      title: TextField
      description: Sample
      api_name: app-home
      source_url:
        html: "https://shopify.dev/docs/api/app-home/latest/web-components/forms/text-field"
        md: "https://shopify.dev/docs/api/app-home/latest/web-components/forms/text-field.md"
      #{frontmatter_extra}
      ---

      # TextField

      ## TextField

      * #{key}

        #{type}

        Description.
    MARKDOWN
  end

  def test_unknown_frontmatter_keys_do_not_raise
    content = markdown(frontmatter_extra: "api_version: v1.0")

    result = Parser.new(content).parse

    assert_equal "app-home", result.metadata.api_name
    refute_respond_to result.metadata, :api_version
  end

  def test_zero_width_space_is_stripped_from_property_keys
    content = markdown(key: "**max​Length**")

    result = Parser.new(content).parse
    property = result.properties.first

    assert_equal "maxLength", property.key
  end

  def test_ellipsis_typographic_symbol_is_preserved_not_dropped
    content = markdown(type: "**one | ... 5 more ...**")

    result = Parser.new(content).parse
    property = result.properties.first

    assert_equal "one | … 5 more …", property.type
  end
end
