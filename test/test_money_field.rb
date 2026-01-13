# frozen_string_literal: true

require "test_helper"

class TestMoneyField < TestCase
  include ComponentExampleTest

  def test_simple
    form_with(model: Post.new) do |form|
      concat form.money_field(:price)
    end

    expected = %(
      <s-money-field name="post[price]"></s-money-field>
    )
    assert_dom_equal expected, form_body(@rendered)
  end
end
