# frozen_string_literal: true

module PolarisFormBuilder
  module Helpers
    def polaris_form_with(**options, &block)
      options[:builder] = PolarisFormBuilder::FormBuilder
      form_with(**options, &block)
    end
  end
end
