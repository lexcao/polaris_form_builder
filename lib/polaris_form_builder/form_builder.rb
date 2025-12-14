# frozen_string_literal: true

require "action_view"
require_relative "polaris_tag"

module PolarisFormBuilder
  class FormBuilder < ActionView::Helpers::FormBuilder
    include ActionView::Helpers::FormTagHelper

    def text_field(method, options = {}, &block)
      error = method_error(method)
      attrs = { error: error }.compact

      html = super(method, options.merge(attrs))

      # When the object has errors, ActionView wraps the generated tag using
      # `ActionView::Base.field_error_proc` (default: `<div class="field_with_errors">...</div>`).
      # We unwrap it so the final output is a single Polaris component tag.
      html = unwrap_field_error_proc(html)

      tag = PolarisTag.new(html)
        .tag_name("s-text-field")
        .exclude_attributes("type")
        .content(capture_block(&block))

      @template.raw(tag.close.to_html)
    end

    def submit(value = nil, options = {})
      value, options = nil, value if value.is_a?(Hash)
      value ||= submit_default_value

      set_default_disable_with value, options

      attrs = {
        type: "submit",
        name: "commit",
        variant: "primary",
        value: value,
      }

      @template.content_tag(
        "s-button",
        value,
        attrs.merge(options)
      )
    end

    private
      def method_error(method)
        if object.respond_to?(:errors) && object.errors[method].present?
          object.errors[method].join(", ")
        end
      end

      def unwrap_field_error_proc(html)
        html = html.to_s

        if match = html.match(/\A<(?<tag>[a-z0-9:_-]+)[^>]*class="[^"]*\bfield_with_errors\b[^"]*"[^>]*>(?<inner>.*)<\/\k<tag>>\z/m)
          match[:inner]
        else
          html
        end
      end

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
