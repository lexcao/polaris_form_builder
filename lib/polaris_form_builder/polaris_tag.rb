# frozen_string_literal: true

module PolarisFormBuilder
  class PolarisTag
    def initialize(html)
      @html = html.to_s
      @steps = []
    end

    def tag_name(new_name)
      @steps << [:tag_name, new_name.to_s]
      self
    end

    def exclude_attributes(*keys)
      @steps << [:exclude_attributes, keys.flatten.map(&:to_s)]
      self
    end

    def content(children)
      return self if children.nil?

      @steps << [:content, children]
      self
    end

    def close
      @steps << [:close]
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
      if (match = html.match(%r{\A<\s*([^\s>/]+)}m))
        old_name = Regexp.escape(match[1])
        html = html.sub(/\A<\s*#{old_name}/m, "<#{new_name}")
        html.sub(%r{</\s*#{old_name}\s*>\z}m, "</#{new_name}>")
      else
        html
      end
    end

    def apply_insert_children(html, children)
      html = apply_ensure_close_tag(html)

      html.sub(%r{\A(<[^>]+>).*?(</[^>]+>)\z}m) do
        "#{::Regexp.last_match(1)}#{children}#{::Regexp.last_match(2)}"
      end
    end

    def apply_ensure_close_tag(html)
      case html
      when %r{\A<[^>]+/>\z}m
        html.sub(%r{\s*/>\z}m, '>') + closing_tag_for(html)

      when /\A<[^>]+>\z/m
        html + closing_tag_for(html)
      when %r{\A<[^>]+>.*</[^>]+>\z}m
        html
      else
        raise ArgumentError, 'Expected a single HTML tag'
      end
    end

    def closing_tag_for(html)
      if (match = html.match(%r{\A<\s*([^\s>/]+)}m))
        "</#{match[1]}>"
      else
        ''
      end
    end

    def apply_remove_attribute(html, key)
      key = Regexp.escape(key.to_s)

      html.sub(/\A<[^>]+>/m) do |opening|
        opening
          .gsub(/\s#{key}(?:=(?:"[^"]*"|'[^']*'|[^\s"'=<>`]+))?/m, '')
          .gsub(/\s+>/m, '>')
          .gsub(%r{\s+/>}m, ' />')
      end
    end
  end
end
