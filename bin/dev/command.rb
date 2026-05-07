# frozen_string_literal: true

require_relative "meta_data"
require_relative "parser"
require_relative "component"
require_relative "screenshot_extractor"

module Command
  class Sync
    def run
      parsed_count = 0
      skipped_count = 0

      MetaData.fetch_all.each do |component|
        begin
          parser = Parser.new(component.markdown_content)
          definition = parser.parse
          definition = with_screenshot_url(definition)
          Component.persist(definition)
          parsed_count += 1
        rescue => e
          skipped_count += 1
          warn "skip parse #{component.name} for error #{e}"
        end
      end

      raise "sync parsed 0 components; skipped #{skipped_count}" if parsed_count.zero?
    end

    private
      def with_screenshot_url(definition)
        html_url = definition.metadata.source_url[:html]
        screenshot_url = ScreenshotExtractor.fetch(html_url)
        metadata = definition.metadata.with(screenshot_url: screenshot_url)

        definition.with(metadata: metadata)
      end
  end

  Step1_FetchComponents = Sync
end
