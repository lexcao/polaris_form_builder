# frozen_string_literal: true

require "action_view"
require_relative "tag"
require_relative "polaris_tag"

module PolarisFormBuilder
  class FormBuilder < ActionView::Helpers::FormBuilder
    include ActionView::Helpers::FormTagHelper

    def text_field(method, options = {}, &block)
      error = method_error(method)
      attrs = { error: error }.compact

      html = without_field_error_proc do
        super(method, options.merge(attrs))
      end

      polaris_input("s-text-field", html, &block)
    end

    def number_field(method, options = {}, &block)
      error = method_error(method)
      attrs = { error: error }.compact

      html = without_field_error_proc do
        super(method, options.merge(attrs))
      end

      polaris_input("s-number-field", html, &block)
    end

    def email_field(method, options = {}, &block)
      error = method_error(method)
      attrs = { error: error }.compact

      html = without_field_error_proc do
        super(method, options.merge(attrs))
      end

      polaris_input("s-email-field", html, &block)
    end

    def password_field(method, options = {}, &block)
      error = method_error(method)
      attrs = { error: error }.compact

      html = without_field_error_proc do
        super(method, options.merge(attrs))
      end

      polaris_input("s-password-field", html, &block)
    end

    def url_field(method, options = {}, &block)
      error = method_error(method)
      attrs = { error: error }.compact

      html = without_field_error_proc do
        super(method, options.merge(attrs))
      end

      polaris_input("s-url-field", html, &block)
    end

    def search_field(method, options = {}, &block)
      error = method_error(method)
      attrs = { error: error }.compact

      html = without_field_error_proc do
        super(method, options.merge(attrs))
      end

      polaris_input("s-search-field", html, &block)
    end

    def text_area(method, options = {}, &block)
      error = method_error(method)
      attrs = { error: error }.compact

      html = without_field_error_proc do
        super(method, options.merge(attrs))
      end

      tag = PolarisTag.new(html)
        .tag_name("s-text-area")
        .normalize_attribute_names
        .content_to_value_attribute
        .content(capture_block(&block))

      @template.raw(tag.close.to_html)
    end

    def select(method, options = {}, &block)
      options = options.dup

      # Get current value from object
      current_value = object.public_send(method) if object.respond_to?(method)

      # Get error message
      error = method_error(method)

      # Build attributes
      attrs = {
        name: "#{object_name}[#{method}]"
      }
      attrs[:value] = current_value if current_value.present?
      attrs[:error] = error if error

      # Merge user-provided options
      attrs.merge!(options)

      # Build opening tag
      attr_string = attrs.map { |k, v| %( #{k}="#{ERB::Util.html_escape(v)}") }.join
      opening_tag = "<s-select#{attr_string}>"

      # Capture block content using the same method as other fields
      content = capture_block(&block) || ""

      # Build closing tag
      closing_tag = "</s-select>"

      @template.raw("#{opening_tag}#{content}#{closing_tag}")
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
      html = without_field_error_proc do
        super(value, options)
      end

      @template.raw Tag.new("s-button", "input")
                       .attr_to_child("value")
                       .apply(html)
    end

    private
      def method_error(method)
        if object.respond_to?(:errors) && object.errors[method].present?
          object.errors[method].to_sentence
        end
      end

    def without_field_error_proc
      original = ::ActionView::Base.field_error_proc
      ::ActionView::Base.field_error_proc = ->(html_tag, _instance) { html_tag }
      yield
    ensure
      ::ActionView::Base.field_error_proc = original
    end

    def polaris_input(tag_name, html, &block)
      tag = Tag.new(tag_name, "input", remove_attributes: %w[type size])
      @template.raw tag.apply(html, capture_block(&block))
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
