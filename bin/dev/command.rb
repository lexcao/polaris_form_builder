# frozen_string_literal: true

require_relative "meta_data"
require_relative "parser"
require "json"

module Command

  class Step1_FetchComponents
    OUTPUT_DIR = File.expand_path("components", __dir__)

    def run
      MetaData.fetch_all[0, 1].each do |component|
        result = Parser.new(component.markdown_content).parse
        file = File.join(OUTPUT_DIR, "#{component.key}.json")

        File.write(file, JSON.pretty_generate(result.to_h))
      end
    end
  end
end
