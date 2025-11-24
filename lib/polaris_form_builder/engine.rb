# frozen_string_literal: true

module PolarisFormBuilder
  class Engine < ::Rails::Engine
    isolate_namespace PolarisFormBuilder

    initializer "polaris_form_builder.view_helpers" do
      ActiveSupport.on_load(:action_view) do
        include PolarisFormBuilder::Helpers
      end
    end
  end
end
