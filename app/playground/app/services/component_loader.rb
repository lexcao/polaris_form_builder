# frozen_string_literal: true

class ComponentLoader
  class << self
    DIR = Rails.root.join("../../data/components")
    CUSTOM_DIR = Rails.root.join("lib/examples")

    def load_json
      Dir.glob(DIR.join("*.json")).map do |path|
        data = JSON.load_file(path, symbolize_names: true)
        Component.new merge_examples(data)
      end.tap { |it| Rails.logger.info "[ComponentLoader] loaded #{it.size} components" }
    end

    def merge_examples(data)
      title = data[:metadata][:title]
      example_file = CUSTOM_DIR.join("#{title}.json")
      return data unless example_file.exist?

      example = JSON.load_file(example_file, symbolize_names: true)
      return data unless example

      Rails.logger.info "[ComponentLoader] merging examples for #{title}"

      data.tap do |result|
        result[:main_example] = example[:main_example]

        result[:examples] = merge_by_name(
          Array(result[:examples]),
          Array(example[:examples])
        )
      end
    end

    private

    def merge_by_name(base, override)
      overrides = override.index_by { _1[:name] }

      merged = base.map do |item|
        item.merge(overrides.delete(item[:name]) || {})
      end

      merged + overrides.values
    end
  end
end
