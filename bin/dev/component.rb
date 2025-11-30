# frozen_string_literal: true

require "json"

module Component
  class Data < Data
    def to_json(*args)
      to_h.to_json(*args)
    end
  end

  MetaData = Data.define(:title, :description, :api_name, :source_url)
  Property = Data.define(:key, :type, :default, :description)
  Example = Data.define(:name, :description, :html_code)
  Definition = Data.define(:metadata, :properties, :examples)

  OUTPUT_DIR = File.expand_path("components", __dir__)

  module_function

  def persist(component)
    file = File.join(OUTPUT_DIR, "#{component.metadata.title}.json")

    File.write(file, JSON.pretty_generate(component))
  end

end
