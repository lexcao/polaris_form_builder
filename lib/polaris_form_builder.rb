# frozen_string_literal: true

require_relative 'polaris_form_builder/version'
require_relative 'polaris_form_builder/form_builder'
require_relative 'polaris_form_builder/railtie' if defined?(Rails::Railtie)

module PolarisFormBuilder
  class Error < StandardError; end
end
