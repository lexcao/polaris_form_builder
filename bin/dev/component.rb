# frozen_string_literal: true

require "json"
require "active_support/core_ext/string"

module Component
  class Data < Data
    def to_json(*args)
      to_h.to_json(*args)
    end
  end

  MetaData = Data.define(:title, :description, :api_name, :source_url, :screenshot_url)
  Property = Data.define(:key, :type, :default, :description)
  Example = Data.define(:name, :description, :html_code, :erb_code)
  Definition = Data.define(:metadata, :properties, :examples)

  OUTPUT_DIR = File.expand_path("../../data/components", __dir__)

  module_function

  def persist(component)
    file = File.join(OUTPUT_DIR, file_name_for(component.metadata.title))

    File.write(file, JSON.pretty_generate(component))
  end

  def file_name_for(title)
    "#{title.titleize.delete(" ")}.json"
  end
end
