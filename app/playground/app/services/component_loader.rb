# frozen_string_literal: true

class ComponentLoader
  DIR = Rails.root.join("../../data/components")

  class << self
    def load_json
      Dir.glob(DIR.join("*.json")).map do |path|
        attributes = JSON.load_file(path, symbolize_names: true)
        attributes[:key] = File.basename(path, ".json").underscore

        Component.new(attributes)
      end.tap { Rails.logger.info "[ComponentLoader] loaded #{it.size} components" }
    end
  end
end
