# frozen_string_literal: true

require "test_helper"

class TestEmailField < TestCase
  include ComponentExampleTest

  def test_simple_email_field
    form_with(model: Post.new) do |form|
      concat form.email_field(:email)
    end

    expected = '<s-email-field name="post[email]"></s-email-field>'
    assert_dom_equal expected, form_body(@rendered)
  end

  def test_email_field_with_placeholder
    form_with(model: Post.new) do |form|
      concat form.email_field(:email, placeholder: "you@example.com")
    end

    assert_includes form_body(@rendered), 'placeholder="you@example.com"'
  end
end
