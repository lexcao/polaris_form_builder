# frozen_string_literal: true

module PolarisFormBuilder
  class PolarisTag
    def initialize(html)
      @html = html.to_s
      @steps = []
    end

    def tag_name(new_name)
      @steps << [ :tag_name, new_name.to_s ]
      self
    end

    def exclude_attributes(*keys)
      @steps << [ :exclude_attributes, keys.flatten.map(&:to_s) ]
      self
    end

    def content(children)
      return self if children.nil?

      @steps << [ :content, children ]
      self
    end

    def normalize_attribute_names
      @steps << [ :normalize_attribute_names ]
      self
    end

    def content_to_value_attribute
      @steps << [ :content_to_value_attribute ]
      self
    end

    def close
      @steps << [ :close ]
      self
    end

    def to_html
      html = @html.dup

      @steps.each do |(step, payload)|
        case step
        when :tag_name
          html = apply_tag_name(html, payload)
        when :exclude_attributes
          payload.each do |key|
            html = apply_remove_attribute(html, key)
          end
        when :normalize_attribute_names
          html = apply_normalize_attribute_names(html)
        when :content_to_value_attribute
          html = apply_content_to_value_attribute(html)
        when :content
          html = apply_insert_children(html, payload)
        when :close
          html = apply_ensure_close_tag(html)
        else
          raise ArgumentError, "Unknown step #{step.inspect}"
        end
      end

      html
    end

    private
      def apply_tag_name(html, new_name)
        if match = html.match(/\A<\s*([^\s>\/]+)/m)
          old_name = Regexp.escape(match[1])
          html = html.sub(/\A<\s*#{old_name}/m, "<#{new_name}")
          html.sub(%r{</\s*#{old_name}\s*>\z}m, "</#{new_name}>")
        else
          html
        end
      end

      def apply_insert_children(html, children)
        html = apply_ensure_close_tag(html)

        html.sub(/\A(<[^>]+>).*?(<\/[^>]+>)\z/m) do
          "#{$1}#{children}#{$2}"
        end
      end

      def apply_ensure_close_tag(html)
        if html.match?(%r{\A<[^>]+/>\z}m)
          html = html.sub(%r{\s*/\>\z}m, ">") + closing_tag_for(html)
          html
        elsif html.match?(%r{\A<[^>]+>\z}m)
          html + closing_tag_for(html)
        elsif html.match?(%r{\A<[^>]+>.*<\/[^>]+>\z}m)
          html
        else
          raise ArgumentError, "Expected a single HTML tag"
        end
      end

      def closing_tag_for(html)
        if match = html.match(/\A<\s*([^\s>\/]+)/m)
          "</#{match[1]}>"
        else
          ""
        end
      end

      def apply_remove_attribute(html, key)
        key = Regexp.escape(key.to_s)

        html.sub(/\A<[^>]+>/m) do |opening|
          opening
            .gsub(/\s#{key}(?:=(?:"[^"]*"|'[^']*'|[^\s"'=<>`]+))?/m, "")
            .gsub(/\s+>/m, ">")
            .gsub(/\s+\/>/m, " />")
        end
      end

      def apply_normalize_attribute_names(html)
        html.sub(/\A<[^>]+>/m) do |opening|
          opening.gsub(/\s([a-z_]+)=/) do
            " #{$1.tr('_', '-')}="
          end
        end
      end

      def apply_content_to_value_attribute(html)
        if match = html.match(/\A(<[^>]+>)(.*?)(<\/[^>]+>)\z/m)
          opening, content, closing = match[1], match[2], match[3]
          content = content.strip

          return html if content.empty?

          if opening.include?(' value=')
            html
          else
            opening = opening.sub(/>/, %( value="#{content}">))
            "#{opening}#{closing}"
          end
        else
          html
        end
      end
  end
end
