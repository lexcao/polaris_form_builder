# frozen_string_literal: true

require "test_helper"

class TestSelect < TestCase
  # include ComponentExampleTest

  # # ComponentExampleTest will automatically generate tests for all examples in Select.json
  # # Here we just add some basic unit tests for specific behaviors
  #
  # def test_select_with_current_value
  #   post = Post.new(category: "newest")
  #   builder = PolarisFormBuilder::FormBuilder.new(:post, post, @view, {})
  #
  #   result = builder.select(:category, label: "Sort by", value: "newest") { "" }
  #
  #   assert_includes result, 'name="post[category]"'
  #   assert_includes result, 'value="newest"'
  #   assert_includes result, 'label="Sort by"'
  # end
  #
  # def test_select_with_error
  #   post = Post.new
  #   post.errors.add(:category, "can't be blank")
  #   builder = PolarisFormBuilder::FormBuilder.new(:post, post, @view, {})
  #
  #   result = builder.select(:category) { "" }
  #
  #   assert_includes result, 'error="can&#39;t be blank"'
  # end
end
