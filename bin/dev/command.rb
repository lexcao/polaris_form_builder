# frozen_string_literal: true

require_relative "meta_data"
require_relative "parser"
require_relative "component"
require_relative "screenshot_extractor"

module Command
  class Step1_FetchComponents
    def run
      MetaData.fetch_all.each do |component|
        begin
          parser = Parser.new(component.markdown_content)
          definition = parser.parse
          definition = with_screenshot_url(definition)
          Component.persist(definition)
        rescue => e
          puts "skip parse #{component.name} for error #{e}"
        end
      end
    end

    private
      def with_screenshot_url(definition)
        html_url = definition.metadata.source_url[:html]
        screenshot_url = ScreenshotExtractor.fetch(html_url)
        metadata = definition.metadata.with(screenshot_url: screenshot_url)

        definition.with(metadata: metadata)
      end
  end
end
