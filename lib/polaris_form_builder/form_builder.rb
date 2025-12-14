# frozen_string_literal: true

require "action_view"
ActionView::Helpers.const_defined?(:FormBuilder)

module PolarisFormBuilder
  class FormBuilder < ActionView::Helpers::FormBuilder
    include ActionView::Helpers::FormTagHelper

    def text_field(method, options = {}, &block)
      value = object.public_send(method) if object.respond_to?(method)
      name = "#{@object_name}[#{method}]"
      error = object.errors[method].presence&.join(", ") if object.respond_to?(:errors)

      attr = {
        name: name,
        value: value,
        error: error
      }.compact

      content = capture_block(&block)

      @template.content_tag("s-text-field", content, options.merge(attr))
    end

    def submit(value = nil, options = {})
      value, options = nil, value if value.is_a?(Hash)
      value ||= submit_default_value

      set_default_disable_with value, options

      attrs = {
        type: "submit",
        name: "commit",
        variant: "primary",
        value: value
      }

      @template.content_tag(
        "s-button",
        value,
        attrs.merge(options)
      )
    end

    private

    def capture_block(&block)
      if block_given?
        # Use the buffer from the block's binding to avoid writing to a different
        # output buffer and duplicating content when the builder is reused.
        capture_buffer = block.binding.eval("@output_buffer") rescue nil
        capture_buffer ||= @template.output_buffer

        if capture_buffer.respond_to?(:capture)
          capture_buffer.capture(&block)
        else
          @template.capture(&block)
        end
      end
    end
  end
end
