# frozen_string_literal: true

require 'action_view'
require_relative 'polaris_tag'

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
                      .tag_name('s-text-field')
                      .exclude_attributes('type')
                      .content(capture_block(&block))

      @template.raw(tag.close.to_html)
    end

    def check_box(method, options = {}, checked_value = '1', unchecked_value = '0')
      options = options.dup

      if (value = options.delete(:value) || options.delete('value'))
        checked_value = value
      end

      error = method_error(method)
      attrs = { error: error }.compact

      html = super(method, options.merge(attrs), checked_value, unchecked_value)
      hidden_html, checkbox_html = extract_check_box_inputs(html)

      tag = PolarisTag.new(checkbox_html)
                      .tag_name('s-checkbox')
                      .exclude_attributes('type')

      @template.raw("#{hidden_html}#{tag.close.to_html}")
    end

    def submit(value = nil, options = {})
      if value.is_a?(Hash)
        options = value
        value = nil
      end
      value ||= submit_default_value

      set_default_disable_with value, options

      attrs = {
        type: 'submit',
        name: 'commit',
        variant: 'primary',
        value: value
      }

      @template.content_tag(
        's-button',
        value,
        attrs.merge(options)
      )
    end

    private

    def method_error(method)
      return unless object.respond_to?(:errors) && object.errors[method].present?

      object.errors[method].join(', ')
    end

    def unwrap_field_error_proc(html)
      html = html.to_s

      if (match = html.match(%r{\A<(?<tag>[a-z0-9:_-]+)[^>]*class="[^"]*\bfield_with_errors\b[^"]*"[^>]*>(?<inner>.*)</\k<tag>>\z}m))
        match[:inner]
      else
        html
      end
    end

    def extract_check_box_inputs(html)
      inputs = html.to_s.scan(/<input\b[^>]*>/i)
      checkbox = inputs.find { |tag| input_type(tag) == 'checkbox' }

      raise ArgumentError, 'Expected check_box to render an input[type=checkbox]' unless checkbox

      hidden = inputs.select { |tag| input_type(tag) == 'hidden' }.join
      [hidden, checkbox]
    end

    def input_type(tag)
      if (match = tag.match(/\stype\s*=\s*(?:"([^"]+)"|'([^']+)'|([^\s>]+))/i))
        (match[1] || match[2] || match[3]).to_s.downcase
      end
    end

    def capture_block(&block)
      return unless block_given?

      # Use the buffer from the block's binding to avoid writing to a different
      # output buffer and duplicating content when the builder is reused.
      capture_buffer = begin
        block.binding.eval('@output_buffer')
      rescue StandardError
        nil
      end
      capture_buffer ||= @template.output_buffer

      if capture_buffer.respond_to?(:capture)
        capture_buffer.capture(&block)
      else
        @template.capture(&block)
      end
    end
  end
end
