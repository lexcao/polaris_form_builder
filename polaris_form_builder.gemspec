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

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).select do |f|
        f.start_with?("lib/", "README", "LICENSE")
    end
  end

  spec.require_paths = [ "lib" ]
end
