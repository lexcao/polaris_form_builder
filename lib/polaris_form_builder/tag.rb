# frozen_string_literal: true

require "nokogiri"

module PolarisFormBuilder
  class Tag
    attr_accessor :name

    def initialize(name, replace, remove_attributes: [])
      @name = name
      @replace = replace
      @remove_attributes = remove_attributes
      @transformations = []
    end

    def attr_to_child(attr_name)
      @transformations << ->(node) {
        if (attr = node.attr(attr_name))
          node.add_child(attr)
        end
      }
      self
    end

    def child_to_attr(attr_name)
      @transformations << ->(node) {
        content = node.content
        if content.present?
          node.set_attribute(attr_name, content)
          node.children.remove
        end
      }
      self
    end

    def attr(attr_name, value)
      return self unless value

      @transformations << ->(node) {
        node.set_attribute(attr_name, value)
      }
      self
    end

    def apply(html, content = nil)
      fragment = Nokogiri::HTML5.fragment(html)
      fragment.css("#{@replace}:not([type=\"hidden\"])").each do |node|
        node.name = @name
        node.inner_html = content if content

        @transformations.each { |transform| transform.call(node) }

        @remove_attributes.each do |key|
          node.remove_attribute(key)
        end
      end
      fragment.to_html
    end
  end
end
