# frozen_string_literal: true

class ComponentLoader
  DIR = Rails.root.join("../../data/components")

  class << self
    def load_json
      Dir.glob(DIR.join("*.json")).map do |path|
        Component.new(JSON.load_file(path, symbolize_names: true))
      end.tap { Rails.logger.info "[ComponentLoader] loaded #{it.size} components" }
    end
  end
end
