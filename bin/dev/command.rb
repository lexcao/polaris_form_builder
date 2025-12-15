# frozen_string_literal: true

require_relative 'meta_data'
require_relative 'parser'
require_relative 'component'

module Command
  class Step1_FetchComponents
    def run
      MetaData.fetch_all.each do |component|
        parser = Parser.new(component.markdown_content)
        definition = parser.parse
        Component.persist(definition)
      rescue StandardError => e
        puts "skip parse #{component.name} for error #{e}"
      end
    end
  end
end
