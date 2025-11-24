# frozen_string_literal: true

require "action_view"

module PolarisFormBuilder
  class FormBuilder < ActionView::Helpers::FormBuilder

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

  end
end
