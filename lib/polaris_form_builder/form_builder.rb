# frozen_string_literal: true

require "action_view"
require_relative "polaris_tag"

module PolarisFormBuilder
  class FormBuilder < ActionView::Helpers::FormBuilder
    include ActionView::Helpers::FormTagHelper

    def text_field(method, options = {}, &block)
      polaris_text_input("s-text-field", method, options, &block)
    end

    def number_field(method, options = {}, &block)
      polaris_text_input("s-number-field", method, options, &block)
    end

    def email_field(method, options = {}, &block)
      polaris_text_input("s-email-field", method, options, &block)
    end

    def password_field(method, options = {}, &block)
      polaris_text_input("s-password-field", method, options, &block)
    end

    def url_field(method, options = {}, &block)
      polaris_text_input("s-url-field", method, options, &block)
    end

    def search_field(method, options = {}, &block)
      polaris_text_input("s-search-field", method, options, &block)
    end

    def text_area(method, options = {}, &block)
      polaris_text_area("s-text-area", method, options, &block)
    end

    def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
      options = options.dup

      if (value = options.delete(:value) || options.delete("value"))
        checked_value = value
      end

      error = method_error(method)
      attrs = { error: error }.compact

      html = without_field_error_proc do
        super(method, options.merge(attrs), checked_value, unchecked_value)
      end
      hidden_html, checkbox_html = extract_check_box_inputs(html)

      tag = PolarisTag.new(checkbox_html)
        .tag_name("s-checkbox")
        .exclude_attributes("type")

      @template.raw("#{hidden_html}#{tag.close.to_html}")
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
      def polaris_text_input(tag_name, method, options = {}, &block)
        error = method_error(method)
        attrs = { error: error }.compact

        html = without_field_error_proc do
          text_field_without_polaris(method, options.merge(attrs))
        end

        tag = PolarisTag.new(html)
          .tag_name(tag_name)
          .exclude_attributes("type", "size")
          .content(capture_block(&block))

        @template.raw(tag.close.to_html)
      end

      def text_field_without_polaris(method, options = {})
        ActionView::Helpers::FormBuilder.instance_method(:text_field).bind(self).call(method, options)
      end

      def polaris_text_area(tag_name, method, options = {}, &block)
        error = method_error(method)
        attrs = { error: error }.compact

        html = without_field_error_proc do
          text_area_without_polaris(method, options.merge(attrs))
        end

        tag = PolarisTag.new(html)
          .tag_name(tag_name)
          .normalize_attribute_names
          .content_to_value_attribute
          .content(capture_block(&block))

        @template.raw(tag.close.to_html)
      end

      def text_area_without_polaris(method, options = {})
        ActionView::Helpers::FormBuilder.instance_method(:text_area).bind(self).call(method, options)
      end

      # Temporarily disable field_error_proc wrapping when calling super.
      # This ensures Polaris components aren't wrapped with error divs regardless
      # of whether polaris_form_with or form_with(builder: ...) is used.
      def without_field_error_proc
        original = ::ActionView::Base.field_error_proc
        ::ActionView::Base.field_error_proc = ->(html_tag, _instance) { html_tag }
        yield
      ensure
        ::ActionView::Base.field_error_proc = original
      end

      def method_error(method)
        if object.respond_to?(:errors) && object.errors[method].present?
          object.errors[method].to_sentence
        end
      end

      def extract_check_box_inputs(html)
        inputs = html.to_s.scan(/<input\b[^>]*>/i)
        checkbox = inputs.find { |tag| input_type(tag) == "checkbox" }

        if checkbox
          hidden = inputs.select { |tag| input_type(tag) == "hidden" }.join
          [ hidden, checkbox ]
        else
          raise ArgumentError, "Expected check_box to render an input[type=checkbox]"
        end
      end

      def input_type(tag)
        if (match = tag.match(/\stype\s*=\s*(?:"([^"]+)"|'([^']+)'|([^\s>]+))/i))
          (match[1] || match[2] || match[3]).to_s.downcase
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
