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
end
