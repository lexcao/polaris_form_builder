# frozen_string_literal: true

require "action_view"
require_relative "tag"

module PolarisFormBuilder
  class FormBuilder < ActionView::Helpers::FormBuilder
    include ActionView::Helpers::FormTagHelper

    # Generate input field methods with identical structure
    # Maps Rails helper name to Polaris component tag
    {
      text_field: "s-text-field",
      number_field: "s-number-field",
      email_field: "s-email-field",
      password_field: "s-password-field",
      url_field: "s-url-field",
      search_field: "s-search-field",
      color_field: "s-color-field",
      date_field: "s-date-field",
      file_field: "s-drop-zone"
    }.each do |helper_name, polaris_tag|
      define_method(helper_name) do |method, options = {}, &block|
        error = method_error(method)
        attrs = { error: error }.compact

        html = without_field_error_proc do
          super(method, options.merge(attrs))
        end

        polaris_input(polaris_tag, html, &block)
      end
    end

    alias_method :drop_zone, :file_field

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

      content = @template.capture(&block) if block_given?

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

    def money_field(method, options = {})
      html = text_field(method, options)

      @template.raw Tag.new("s-money-field", "s-text-field").apply(html)
    end

    def color_picker(method, options = {})
      html = text_field(method, options)

      @template.raw Tag.new("s-color-picker", "s-text-field").apply(html)
    end

    def date_picker(method, options = {})
      options = options.dup
      picker_type = options.delete(:type)
      html = date_field(method, options)

      tag = Tag.new("s-date-picker", "s-date-field")
      tag.attr("type", picker_type) if picker_type
      @template.raw tag.apply(html)
    end

    def switch(method, options = {})
      html = check_box(method, options, options.fetch(:value, "1"))

      @template.raw Tag.new("s-switch", "s-checkbox").apply(html)
    end

    def choice_list(method, options = {}, &block)
      select(method, options.delete(:choices), options, &block)
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
      content = @template.capture(&block) if block_given?
      @template.raw tag.apply(html, content)
    end
  end
end
