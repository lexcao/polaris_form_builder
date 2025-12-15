# frozen_string_literal: true

require_relative 'form_builder'

module PolarisFormBuilder
  module Helpers
    def polaris_form_with(**options, &block)
      form_with(**options.merge(builder: PolarisFormBuilder::FormBuilder), &block)
    end
  end
end
