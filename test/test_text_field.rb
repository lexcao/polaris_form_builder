# frozen_string_literal: true

require "test_helper"

class TestTextField < TestCase
  include ComponentExampleTest

  def test_text_field
    form_with(model: Post.new) do |form|
      concat form.text_field(:title)
    end

    expected = '<s-text-field name="post[title]"></s-text-field>'
    assert_dom_equal expected, form_body(@rendered)
  end

  def test_text_field_block_inside_nested_inline_render
    inner = <<~INNER
      <%= form.text_field :title, label: "Discount code" do %>
        <s-icon slot="accessory" type="info"></s-icon>
      <% end %>
    INNER

    render_erb(<<~ERB, locals: { inner: inner })
      <%= form_with model: Post.new, url: "/foo" do |form| %>
        <%= render inline: inner, locals: { form: form } %>
      <% end %>
    ERB

    expected = %(
      <s-text-field name="post[title]" label="Discount code">
        <s-icon slot="accessory" type="info"></s-icon>
      </s-text-field>
    )
    assert_dom_equal expected, form_body(@rendered)
  end
end
