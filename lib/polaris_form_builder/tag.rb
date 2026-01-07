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
      @attribute_to_child ||= ->(node) {
        node.add_child(node.attr(name))
      }
      self
    end

    def apply(html, content = nil)
      fragment = Nokogiri::HTML5.fragment(html)
      fragment.css(@replace).each do |node|
        node.name = @name
        node.add_child(content) if content

        @attribute_to_child&.call(node)

        @remove_attributes.each do |key|
          node.remove_attribute(key)
        end
      end
      fragment.to_html
    end
  end
end
