# frozen_string_literal: true

require "test_helper"

class TestChoiceList < TestCase
  include ComponentExampleTest

  def test_choice_list_renders_custom_tag_with_attributes
    form_with(model: Post.new) do |form|
      concat(form.choice_list(:category, label: "Category", details: "Pick one") do
        concat content_tag("s-choice", "Ruby", value: "Ruby")
        concat content_tag("s-choice", "Rails", value: "Rails")
      end)
    end

    expected = %(
      <s-choice-list name="post[category]" label="Category" details="Pick one">
        <s-choice value="Ruby">Ruby</s-choice>
        <s-choice value="Rails">Rails</s-choice>
      </s-choice-list>
    )
    assert_dom_equal expected, form_body(@rendered)
  end

  def test_choice_list_inside_nested_inline_render
    inner = <<~INNER
      <%= form.choice_list :category, label: "Category" do %>
        <s-choice value="Ruby">Ruby</s-choice>
        <s-choice value="Rails">Rails</s-choice>
      <% end %>
    INNER

    render_erb(<<~ERB, locals: { inner: inner })
      <%= form_with model: Post.new, url: "/foo" do |form| %>
        <%= render inline: inner, locals: { form: form } %>
      <% end %>
    ERB

    expected = %(
      <s-choice-list name="post[category]" label="Category">
        <s-choice value="Ruby">Ruby</s-choice>
        <s-choice value="Rails">Rails</s-choice>
      </s-choice-list>
    )
    assert_dom_equal expected, form_body(@rendered)
  end
end
