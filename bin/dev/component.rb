# frozen_string_literal: true

module Component
  class Data < Data
    def to_json(*args)
      to_h.to_json(*args)
    end
  end

  MetaData = Data.define(:title, :description, :api_name, :source_url)
  Property = Data.define(:key, :type, :default, :description)
  Example = Data.define(:name, :description, :html_code)
  Definition = Data.define(:metadata, :name, :properties, :examples)

  module_function

end
