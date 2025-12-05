# frozen_string_literal: true

require "nokogiri"
require "active_support/core_ext/string"
require "active_support/core_ext/object"
require "action_view/helpers/tag_helper"
require "set"
require_relative "meta_data"

module Converter
  SPECIAL_COMPONENTS = {
    "checkbox" => "check_box"
  }.freeze
  BOOLEAN_ATTRIBUTES =
    Set.new(::ActionView::Helpers::TagHelper::BOOLEAN_ATTRIBUTES.map(&:to_s))

  module_function

  def html_to_erb(html, form_var: "form")
    return "" if html.blank?

    fragment = Nokogiri::HTML::DocumentFragment.parse(html.to_s)

    fragment
      .children
      .map { |child| convert_node(child, form_var) }
      .join
      .strip
  end

  # -------------------------
  # 2. tag 处理方法
  # -------------------------
  def convert_node(node, form_var)
    case node
    when Nokogiri::XML::Text
      node.to_html
    when Nokogiri::XML::Element
      if field_component?(node)
        convert_field_tag(node, form_var)
      else
        convert_normal_tag(node, form_var)
      end
    else
      node.to_html
    end
  end

  # 普通标签：原样输出，只递归处理子节点
  def convert_normal_tag(node, form_var)
    open = "<#{node.name}#{html_attributes(node)}>"
    inner = node.children.map { |child| convert_node(child, form_var) }.join
    close = "</#{node.name}>"
    "#{open}#{inner}#{close}"
  end

  # field 组件：替换为 `<%= form.xxx :field_name, ... %>`
  def convert_field_tag(node, form_var)
    helper_name = component_method_name(node.name)
    field_name = infer_field_name(node)
    kwargs = ruby_attributes(node)

    args =
      if kwargs.empty?
        ":#{field_name}"
      else
        ":#{field_name}, #{kwargs}"
      end

    "<%= #{form_var}.#{helper_name} #{args} %>"
  end

  # -------------------------
  # 1. A：field component 名字转换
  # -------------------------
  def component_method_name(tag_name)
    # s-text-field → text_field
    base = tag_name.to_s.sub(/\As-/, "").tr("-", "_")
    # checkbox → check_box
    SPECIAL_COMPONENTS.fetch(base, base)
  end

  def field_component?(node)
    MetaData::COMPONENTS.include?(component_key(node.name))
  end

  def component_key(tag_name)
    tag_name.to_s.sub(/\As-/, "").tr("-", "").downcase
  end

  # 简单推断 symbol 名：
  # 1. 有 name → from name
  # 2. 否则用 label
  # 3. fallback :field
  def infer_field_name(node)
    if (name = node["name"]).present?
      # order-quantity / orderQuantity / order[quantity] → order_quantity
      base = name.tr("[]", "").tr("-", "_").underscore
    elsif (label = node["label"]).present?
      base = label.parameterize.underscore
    else
      base = "field"
    end

    base.to_sym
  end

  # -------------------------
  # 3. attributes 替换方法
  # -------------------------

  # 把 HTML 属性保留在普通标签上：  label="Store name"
  def html_attributes(node)
    return "" if node.attribute_nodes.empty?

    " " + node.attribute_nodes.map { |a| %{#{a.name}="#{a.value}"} }.join(" ")
  end

  # 把组件属性转成 Ruby keyword 参数：
  #
  #   label="Store name", placeholder="Become a merchant"
  #   → 'label: "Store name", placeholder: "Become a merchant"'
  #
  def ruby_attributes(node)
    node.attribute_nodes
        .reject { |a| %w[name id].include?(a.name) } # name/id 用来推断 field_name，不写入 options
        .map { |a| ruby_kw_pair(a) }
        .compact
        .join(", ")
  end

  # 单个属性：key="value" → key: "value"
  def ruby_kw_pair(attr)
    key = ruby_key(attr.name)
    val = ruby_value(attr)
    "#{key}: #{val}"
  end

  # key 处理：横杠 → 下划线，并 underscore
  #
  #   "maxLength" / "max-length" → max_length
  #
  def ruby_key(name)
    name.tr("-", "_").underscore.to_sym
  end

  # 值处理：目前简单字符串 → inspect
  # 你之后可以在这里扩展 true/false/数字等类型转换
  def ruby_value(attr)
    raw = attr.value
    attr_name = attr.name.to_s.downcase

    return boolean_value(raw) if boolean_attribute?(attr_name)

    string_value(raw)
  end

  def boolean_attribute?(name)
    BOOLEAN_ATTRIBUTES.include?(name)
  end

  def boolean_value(raw)
    raw.blank? || raw.to_s.downcase == "true"
  end

  def string_value(raw)
    raw.inspect
  end
end
