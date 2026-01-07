# frozen_string_literal: true

require "nokogiri"

module PolarisFormBuilder
  class Tag
    attr_accessor :name

    def initialize(name, replace)
      @name = name
      @replace = replace
    end

    def apply(html, content = nil)
      fragment = Nokogiri::HTML5.fragment(html)
      fragment.css(@replace).each do |node|
        node.name = @name
        node.add_child(content) if content

        # the original attributes are not needed from Polaris Web Components
        node.remove_attribute("type")
        node.remove_attribute("size")
      end
      fragment.to_html
    end
  end
end
