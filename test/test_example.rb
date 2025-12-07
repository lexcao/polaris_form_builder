# frozen_string_literal: true

require "test_helper"

class TestExample < TestCase
  def self.load_examples(component_name)
    path = File.expand_path("fixtures/components/#{component_name}.json", __dir__)
    metadata = JSON.parse(File.read(path))
    metadata.fetch("examples", [])
  end

  include ComponentExampleTest

  def test_generated_example_methods_exist
    generated = self.class.instance_methods.grep(/^test_example_/)
    assert_includes generated, :test_example_simple_example
  end
end
