# frozen_string_literal: true

require "nokogiri"
require "active_support/core_ext/string"
require "active_support/core_ext/object"
require_relative "meta_data"

module Converter
  SPECIAL_COMPONENTS = {
    "checkbox" => "check_box"
  }.freeze

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
    children = convert_children(node, form_var)

    if helper_name == "select"
      #   Select 需要把 children options 转为 choices attributes
      # 两种都存在的情况下，不支持嵌套结构，不处理
      choices = []
      child_names = node.element_children.map(&:name)
      unless child_names.include?("s-option") && child_names.include?("s-option-group")
        choices = collect_choices node
        children = nil
      end
      kwargs = kwargs.empty? ? "#{choices}" : "#{choices}, {}, { #{kwargs} }"
    end

    args = kwargs.empty? ? ":#{field_name}" : ":#{field_name}, #{kwargs}"

    if children.present?
      <<~ERB
        <%= #{form_var}.#{helper_name} #{args} do %>#{children}<% end %>
      ERB
    else
      "<%= #{form_var}.#{helper_name} #{args} %>"
    end
  end

  def collect_choices(select)
    choices = []
    select.element_children.each do |node|
      case node.name
      when "s-option"
        choices << [ node.text.strip, node["value"] ]
      when "s-option-group"
        group_label = node["label"].to_s
        group_options = node.css("s-option").map { |opt|
          [ opt.text.strip, opt["value"] ] }
        choices << [ group_label, group_options ]
      end
    end

    choices
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

    " " + node.attribute_nodes.map { |a| %(#{a.name}="#{a.value}") }.join(" ")
  end

  # 把组件属性转成 Ruby keyword 参数：
  #
  #   label="Store name", placeholder="Become a merchant"
  #   → 'label: "Store name", placeholder: "Become a merchant"'
  #
  def ruby_attributes(node)
    node.attribute_nodes
        .reject { |a| %w[name].include?(a.name) } # name/id 用来推断 field_name，不写入 options
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
    return true if raw.to_s.casecmp(attr.name.to_s).zero?
    return true if raw.blank?
    return true if raw.to_s.casecmp("true").zero?
    return false if raw.to_s.casecmp("false").zero?

    string_value(raw)
  end

  def string_value(raw)
    raw.inspect
  end

  def convert_children(node, form_var)
    return "" unless node.element_children.any? || node.children.any? { |child| child.text? && child.text.strip.present? }

    node
      .children
      .map { |child| convert_node(child, form_var) }
      .join
  end
end
