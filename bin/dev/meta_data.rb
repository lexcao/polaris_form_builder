# frozen_string_literal: true

require "nokogiri"
require "active_support/core_ext/string"
require_relative 'fetch'

module MetaData
  BASE_URL = "https://shopify.dev/docs/api/app-home/polaris-web-components/forms/"
  Result = Data.define(:key, :name, :url)

  COMPONENTS = %w[checkbox choicelist colorfield colorpicker datefield datepicker dropzone emailfield moneyfield numberfield passwordfield searchfield select switch textarea textfield urlfield]
  DATA = COMPONENTS.map { |component| Result.new(key: component, name: component.camelcase, url: "#{BASE_URL}#{component}") }
  private_constant :DATA

  module_function

  def list
    DATA
  end
end
