# frozen_string_literal: true

require_relative "lib/polaris_form_builder/version"

Gem::Specification.new do |spec|
  spec.name = "polaris_form_builder"
  spec.version = PolarisFormBuilder::VERSION
  spec.authors = [ "Lex Cao" ]
  spec.email = [ "lexcao@foxmail.com" ]

  spec.summary = "Rails form builder helpers for Shopify Polaris web components."
  spec.description = "Rails form helpers and view bindings to build forms with Shopify Polaris web components."
  spec.homepage = "https://github.com/lexcao/polaris_form_builder"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/lexcao/polaris_form_builder"

  spec.files = Dir.glob("lib/**/*.rb", base: __dir__) + %w[README.md LICENSE.txt]

  spec.require_paths = [ "lib" ]
end
