# frozen_string_literal: true

require "test_helper"

class TestExample < TestCase
  include ComponentExampleTest

  def test_generated_example_methods_exist
    generated = self.class.instance_methods.grep(/^test_example_/)
    assert_includes generated, :test_example_simple_example
  end
end
