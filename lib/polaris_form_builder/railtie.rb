# frozen_string_literal: true

require_relative 'helpers'

module PolarisFormBuilder
  class Railtie < ::Rails::Railtie
    initializer 'polaris_form_builder.view_helpers' do |app|
      ActiveSupport.on_load(:action_view) do
        include PolarisFormBuilder::Helpers
      end
    end
  end
end
