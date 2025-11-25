# frozen_string_literal: true

require "action_view"

module PolarisFormBuilder
  class FormBuilder < ActionView::Helpers::FormBuilder
    include ActionView::Helpers::FormTagHelper

    def text_field(method, options = {})
      value = object.public_send(method) if object.respond_to?(method)
      name  = "#{@object_name}[#{method}]"
      error = object.errors[method].presence&.join(", ")

      @template.content_tag(
        "s-text-field",
        nil,
        {
          name: name,
          value: value,
          error: error
        }.compact
      )
    end

    def submit(value = nil, options = {})
      value, options = nil, value if value.is_a?(Hash)
      value ||= submit_default_value

      set_default_disable_with value, options

      @template.content_tag(
        "s-button",
        nil,
        options.merge({
          type: "submit",
          name: "commit",
          value: value,
        })
      )
    end

  end
end
