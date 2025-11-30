# frozen_string_literal: true

class ComponentLoader
  DIR = Rails.root.join("lib/components")

  def self.load_json
    Dir.glob(DIR.join("*.json")).map do |path|
      data = JSON.parse(File.read(path))
      Component.new(data)
    end
  end
end
