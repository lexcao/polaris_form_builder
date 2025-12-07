# frozen_string_literal: true

require "action_view"
require "erb"
require "cgi"

module PolarisFormBuilder
  class FormBuilder < ActionView::Helpers::FormBuilder
    include ActionView::Helpers::FormTagHelper

    BOOLEAN_ATTRIBUTES = ActionView::Helpers::TagHelper::BOOLEAN_ATTRIBUTES.map(&:to_s).freeze

    def text_field(method, options = {}, &block)
      options = options.dup
      accessory_content = extract_accessory(options)
      block_content = capture_block_content(&block) if block_given?
      attrs = text_field_attributes(method, options)

      content = []
      content << accessory_content if accessory_content
      content << block_content if block_content.present?
      content.compact!

      tag_string(
        "s-text-field",
        attrs,
        content: content.presence,
        self_close: self_closing_text_field?(attrs, content)
      )
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
      def text_field_attributes(method, options)
        value = options.key?(:value) ? options.delete(:value) : object_value(method)
        error = options.key?(:error) ? options.delete(:error) : object_error(method)
        name  = options.delete(:name) || "#{@object_name}[#{method}]"

        options.merge(
          name: name,
          value: value,
          error: error
        )
      end

      def object_value(method)
        object.public_send(method) if object.respond_to?(method)
      end

      def object_error(method)
        return unless object.respond_to?(:errors)

        object.errors[method].presence&.join(", ")
      end

      def extract_accessory(options)
        accessory = options.delete(:accessory)
        return accessory if accessory.present?

        tooltip_id = options.delete(:tooltip_id) || options.delete(:interest_for)
        tooltip_id ||= latest_tooltip_id
        return unless tooltip_id

        tag_string(
          "s-icon",
          { slot: "accessory", interestFor: tooltip_id, type: "info" },
          self_close: true
        )
      end

      def latest_tooltip_id
        buffer = CGI.unescapeHTML(@template.output_buffer.to_s)
        buffer.scan(/<s-tooltip[^>]*id="([^"]+)"/).last&.first
      end

      def capture_block_content(&block)
        buffer = @template.output_buffer
        starting_length = buffer.respond_to?(:length) ? buffer.length : 0

        captured = @template.capture(&block)

        if buffer.respond_to?(:slice!)
          buffer.slice!(starting_length..-1)
        end

        captured
      end

      def self_closing_text_field?(attrs, content)
        content.blank? && (attrs.key?(:prefix) || attrs.key?(:suffix))
      end

      def tag_string(name, attrs, content: nil, self_close: false)
        attr_string = build_attributes(attrs)
        spacing = attr_string.empty? ? "" : " #{attr_string}"

        if self_close
          "<#{name}#{spacing} />".html_safe
        else
          inner = build_content(content)
          "<#{name}#{spacing}>#{inner}</#{name}>".html_safe
        end
      end

      def build_content(content)
        return "" if content.blank?

        Array(content).each_with_object(ActiveSupport::SafeBuffer.new) do |part, buffer|
          next if part.nil?

          safe_part =
            if part.respond_to?(:html_safe?) && part.html_safe?
              part
            else
              ERB::Util.html_escape(part)
            end

          buffer.safe_concat(safe_part)
        end
      end

      def build_attributes(attrs)
        attrs.each_with_object([]) do |(key, value), parts|
          next if value.nil?

          attr_name = key.to_s.tr("_", "-")

          if boolean_attribute?(attr_name)
            next unless value

            parts << attr_name
          else
            parts << %(#{attr_name}="#{ERB::Util.html_escape(value)}")
          end
        end.join(" ")
      end

      def boolean_attribute?(name)
        BOOLEAN_ATTRIBUTES.include?(name.to_s.downcase)
      end
  end
end
