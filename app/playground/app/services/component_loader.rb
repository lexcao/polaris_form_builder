# frozen_string_literal: true

class ComponentLoader
  DIR = Rails.root.join("../../data/components")

  def self.load_json
    Dir.glob(DIR.join("*.json")).map do |path|
      data = JSON.parse(File.read(path))
      Component.new(data)
    end.tap { |it| Rails.logger.info "[ComponentLoader] loaded #{it.size} components" }
  end
end
