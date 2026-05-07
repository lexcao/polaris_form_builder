# frozen_string_literal: true

require "active_support/core_ext/string"
require_relative 'fetch'

module MetaData
  BASE_URL = "https://shopify.dev/docs/api/app-home/web-components/forms/"
  Result = Data.define(:key, :name, :markdown_content, :markdown_url)

  COMPONENTS = %w[checkbox choicelist colorfield colorpicker datefield datepicker dropzone emailfield moneyfield numberfield passwordfield searchfield select switch textarea textfield urlfield]
  SLUGS = {
    "choicelist" => "choice-list",
    "colorfield" => "color-field",
    "colorpicker" => "color-picker",
    "datefield" => "date-field",
    "datepicker" => "date-picker",
    "dropzone" => "drop-zone",
    "emailfield" => "email-field",
    "moneyfield" => "money-field",
    "numberfield" => "number-field",
    "passwordfield" => "password-field",
    "searchfield" => "search-field",
    "textarea" => "text-area",
    "textfield" => "text-field",
    "urlfield" => "url-field"
  }
  DATA = COMPONENTS.map { |component| Result.new(key: component, name: component.camelcase, markdown_url: "#{BASE_URL}#{SLUGS.fetch(component, component)}.md", markdown_content: "") }
  private_constant :DATA
  private_constant :SLUGS

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
