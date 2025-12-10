# frozen_string_literal: true

require "json"
require "active_support/core_ext/string/inflections"

module ComponentExampleLoader
  class ExampleNotFound < StandardError; end

  def self.load(component, name: "Main example")
    data = JSON.parse(File.read(component_path(component)))
    example = Array(data["examples"]).find { |item| item["name"] == name }
    raise ExampleNotFound, "Example #{name.inspect} not found for #{component}" unless example

    example
  end

  def self.component_path(component)
    File.expand_path("components/#{component.to_s.camelize}.json", __dir__)
  end
end
