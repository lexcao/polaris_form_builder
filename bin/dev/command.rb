# frozen_string_literal: true

require_relative "meta_data"
require_relative "parser"
require_relative "component"

module Command

  class Step1_FetchComponents
    def run
      MetaData.fetch_all[0, 1].each do |component|
        parser = Parser.new(component.markdown_content)
        definition = parser.parse
        Component.persist(definition)
      end
    end
  end
end
