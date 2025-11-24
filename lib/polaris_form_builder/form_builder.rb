# frozen_string_literal: true

module PolarisFormBuilder
  class FormBuilder < ActionView::Helpers::FormBuilder

    def text_field(method, options = {})
      value = object.respond_to?(method) ? object.public_send(method) : nil
      name  = "#{@object_name}[#{method}]"

      label = options.delete(:label) || method.to_s.humanize
      placeholder = options.delete(:placeholder)
      error       = object.errors[method].presence&.join(", ")

      @template.tag.public_send(
        "s-input",
        {
          name: name,
          value: value,
          label: label,
          placeholder: placeholder,
          error: error
        }.compact
      )
    end

  end
end
