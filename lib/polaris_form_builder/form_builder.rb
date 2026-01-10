# frozen_string_literal: true

require "action_view"
require_relative "tag"

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

      @template.raw Tag.new("s-text-area", "textarea", remove_attributes: %w[type size])
                       .child_to_attr("value")
                       .apply(html)
    end

    def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
      error = method_error(method)
      attrs = { error: error }.compact

      html = without_field_error_proc do
        super(method, options.merge(attrs), checked_value, unchecked_value)
      end

      polaris_input("s-checkbox", html)
    end

    def select(method, choices = nil, options = {}, html_options = {}, &block)
      error = method_error(method)
      attrs = { error: error }.compact

      html = without_field_error_proc do
        super(method, choices, options.merge(attrs), html_options)
      end

      content = capture_block(&block)

      select_tag = Tag.new("s-select", "select")
      select_tag.attr("value", object.send(method)) if object.respond_to?(method)

      html = select_tag.apply(html, content)
      html = Tag.new("s-option-group", "optgroup").apply(html)
      html = Tag.new("s-option", "option").apply(html)

      @template.raw html
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
