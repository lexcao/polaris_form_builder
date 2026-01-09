# frozen_string_literal: true

require_relative "meta_data"
require_relative "parser"
require_relative "component"

module Command
  class Step1_FetchComponents
    def run
      MetaData.fetch_all.select do
        it.key == "select"
      end.each do |component|
        begin
        parser = Parser.new(component.markdown_content)
        definition = parser.parse
        Component.persist(definition)
        rescue => e
          puts "skip parse #{component.name} for error #{e}"
        end
      end
    end
  end
end
