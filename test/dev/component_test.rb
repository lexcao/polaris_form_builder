# frozen_string_literal: true

require "minitest/autorun"
require_relative "../../bin/dev/component"

class ComponentTest < Minitest::Test
  def test_file_name_for_normalizes_display_titles_to_component_names
    assert_equal "TextField.json", Component.file_name_for("Text field")
    assert_equal "ChoiceList.json", Component.file_name_for("Choice list")
    assert_equal "URLField.json", Component.file_name_for("URL field")
  end
end
