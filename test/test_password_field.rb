# frozen_string_literal: true

require "test_helper"

class TestPasswordField < TestCase
  include ComponentExampleTest

  def test_simple_password_field
    form_with(model: Post.new) do |f|
      concat f.password_field(:password)
    end

    expected = '<s-password-field name="post[password]"></s-password-field>'
    assert_dom_equal expected, form_body(@rendered)
  end

  def test_password_field_with_label
    form_with(model: Post.new) do |f|
      concat f.password_field(:password, label: "Password")
    end

    assert_includes form_body(@rendered), 'label="Password"'
  end

  def test_password_field_does_not_fill_value_from_object
    post = Post.new(password: "secret123")

    form_with(model: post) do |f|
      concat f.password_field(:password)
    end

    # Rails password_field does not render value attribute for security
    refute_includes form_body(@rendered), 'value="secret123"'
    refute_includes form_body(@rendered), "secret123"
  end

  def test_password_field_respects_explicit_value_option
    post = Post.new(password: "secret123")

    form_with(model: post) do |f|
      concat f.password_field(:password, value: "override")
    end

    # Explicit value option should be rendered if provided
    assert_includes form_body(@rendered), 'value="override"'
  end
end
