# frozen_string_literal: true

require "nokogiri"

module PolarisFormBuilder
  class Tag
    attr_accessor :name

    def initialize(name, replace, remove_attributes: [])
      @name = name
      @replace = replace
      @remove_attributes = remove_attributes
    end

    def attr_to_child(name)
      @attr_to_child ||= ->(node) {
        if (attr = node.attr(name))
          node.add_child(attr)
        end
      }
      self
    end

    def child_to_attr(name)
      @child_to_attr ||= ->(node) {
        content = node.content
        if content.present?
          node.set_attribute(name, content)
          node.children.remove
        end
      }
      self
    end

    def attr(name, value)
      return self unless value

      @attr ||= ->(node) {
        node.set_attribute(name, value)
      }
      self
    end

    def apply(html, content = nil)
      fragment = Nokogiri::HTML5.fragment(html)
      fragment.css("#{@replace}:not([type=\"hidden\"])").each do |node|
        node.name = @name
        node.inner_html = content if content

        @attr&.call(node)
        @attr_to_child&.call(node)
        @child_to_attr&.call(node)

        @remove_attributes.each do |key|
          node.remove_attribute(key)
        end
      end
      fragment.to_html
    end
  end
end
