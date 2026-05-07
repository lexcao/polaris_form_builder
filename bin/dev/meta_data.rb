# frozen_string_literal: true

require "active_support/core_ext/string"
require_relative 'fetch'

module MetaData
  BASE_URL = "https://shopify.dev/docs/api/app-home/web-components/forms/"
  Result = Data.define(:key, :name, :markdown_content, :markdown_url)

  COMPONENTS = %w[checkbox choicelist colorfield colorpicker datefield datepicker dropzone emailfield moneyfield numberfield passwordfield searchfield select switch textarea textfield urlfield]
  SLUG_SUFFIX = /(field|list|picker|zone|area)\z/
  DATA = COMPONENTS.map do |component|
    slug = component.sub(SLUG_SUFFIX, '-\1')
    Result.new(key: component, name: component.camelcase, markdown_url: "#{BASE_URL}#{slug}.md", markdown_content: "")
  end
  private_constant :DATA
  private_constant :SLUG_SUFFIX

  module_function

  def list
    DATA
  end

  def fetch_all
    DATA.map do |component|
      component.with(markdown_content: Fetch.with_cache(component.markdown_url))
    end
  end
end
