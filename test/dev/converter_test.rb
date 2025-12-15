# frozen_string_literal: true

require "minitest/autorun"
require_relative "../../bin/dev/converter"

class ConverterTest < Minitest::Test
  # 简单 TextField：从 label 推断 field 名 + attributes 转换
  def test_text_field_from_label
    html = <<~HTML
      <s-text-field label="Store name" placeholder="Become a merchant"></s-text-field>
    HTML

    expected = %(
      <%= form.text_field :store_name, label: "Store name", placeholder: "Become a merchant" %>
    )

    assert_equal normalize(expected), normalize(Converter.html_to_erb(html))
  end

  # 从 name 属性推断 field 名
  def test_field_name_from_name_attribute
    html = <<~HTML
      <s-text-field name="order-quantity" label="Order quantity"></s-text-field>
    HTML

    expected = %(
      <%= form.text_field :order_quantity, label: "Order quantity" %>
    )

    assert_equal normalize(expected), normalize(Converter.html_to_erb(html))
  end

  # checkbox 特殊映射： s-checkbox → form.check_box
  def test_checkbox_special_mapping
    html = <<~HTML
      <s-checkbox label="Accept terms"></s-checkbox>
    HTML

    expected = %(
      <%= form.check_box :accept_terms, label: "Accept terms" %>
    )

    assert_equal normalize(expected), normalize(Converter.html_to_erb(html))
  end

  # 外层标签保持不变，只替换内部 field component
  def test_nested_tags_are_preserved
    html = <<~HTML
      <s-stack gap="base">
        <s-text-field label="Store name"></s-text-field>
        <s-text-field label="Store description"></s-text-field>
      </s-stack>
    HTML

    expected = <<~ERB
      <s-stack gap="base">
        <%= form.text_field :store_name, label: "Store name" %>
        <%= form.text_field :store_description, label: "Store description" %>
      </s-stack>
    ERB

    assert_equal normalize(expected), normalize(Converter.html_to_erb(html))
  end

  # attributes key 转换：横杠 / camelCase → snake_case
  def test_attribute_key_transform
    html = <<~HTML
      <s-text-field
        label="Store name"
        max-length="10"
        autoComplete="off"
      ></s-text-field>
    HTML

    # 期望：
    #   max-length   → max_length
    #   autoComplete → auto_complete
    expected_substr = 'max_length: "10", autocomplete: "off"'

    converted = Converter.html_to_erb(html)

    assert_includes converted, expected_substr
  end

  # boolean attribute: required → required: true
  def test_boolean_required_attribute
    html = <<~HTML
      <s-text-field label="Store name" required></s-text-field>
    HTML

    expected = %(
      <%= form.text_field :store_name, label: "Store name", required: true %>
    )

    assert_equal normalize(expected), normalize(Converter.html_to_erb(html))
  end

  def test_boolean_attribute_not_in_html_boolean_list
    html = <<~HTML
      <s-checkbox label="Select all" indeterminate checked></s-checkbox>
    HTML

    expected = %(
      <%= form.check_box :select_all, label: "Select all", indeterminate: true, checked: true %>
    )

    assert_equal normalize(expected), normalize(Converter.html_to_erb(html))
  end

  # form_var 自定义
  def test_custom_form_var
    html = <<~HTML
      <s-text-field label="Store name"></s-text-field>
    HTML

    expected = %(
      <%= f.text_field :store_name, label: "Store name" %>
    )

    assert_equal normalize(expected), normalize(Converter.html_to_erb(html, form_var: "f"))
  end

  def test_field_with_accessory_slot_children
    html = <<~HTML
      <s-text-field label="Discount code">
        <s-icon slot="accessory" type="info"></s-icon>
      </s-text-field>
    HTML

    expected = <<~ERB
      <%= form.text_field :discount_code, label: "Discount code" do %>
        <s-icon slot="accessory" type="info"></s-icon>
      <% end %>
    ERB

    assert_equal normalize(expected), normalize(Converter.html_to_erb(html))
  end

  def test_field_with_custom_slot_children
    html = <<~HTML
      <s-text-field label="Order quantity">
        <s-badge slot="suffix">Unit</s-badge>
      </s-text-field>
    HTML

    expected = <<~ERB
      <%= form.text_field :order_quantity, label: "Order quantity" do %>
        <s-badge slot="suffix">Unit</s-badge>
      <% end %>
    ERB

    assert_equal normalize(expected), normalize(Converter.html_to_erb(html))
  end

  private

  def normalize(str)
    str.to_s.gsub(/\s+/, " ").strip
  end
end
