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
  # 2. Tag processing
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

  # Non-field tags: keep as-is; only process children
  def convert_normal_tag(node, form_var)
    open = "<#{node.name}#{html_attributes(node)}>"
    inner = node.children.map { |child| convert_node(child, form_var) }.join
    close = "</#{node.name}>"
    "#{open}#{inner}#{close}"
  end

  # Field components: replace with `<%= form.xxx :field_name, ... %>`
  def convert_field_tag(node, form_var)
    helper_name = component_method_name(node.name)
    field_name = infer_field_name(node)
    kwargs = ruby_attributes(node)
    children = convert_children(node, form_var)

    args = kwargs.empty? ? ":#{field_name}" : ":#{field_name}, #{kwargs}"

    if children.present?
      <<~ERB
        <%= #{form_var}.#{helper_name} #{args} do %>#{children}<% end %>
      ERB
    else
      "<%= #{form_var}.#{helper_name} #{args} %>"
    end
  end

  # -------------------------
  # 1. Field component name mapping
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

  # Infer a symbol name:
  # 1) Prefer `name`
  # 2) Otherwise use `label`
  # 3) Fall back to :field
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
  # 3. Attribute conversion
  # -------------------------

  # Keep HTML attributes on normal tags, e.g. label="Store name"
  def html_attributes(node)
    return "" if node.attribute_nodes.empty?

    " " + node.attribute_nodes.map { |a| %(#{a.name}="#{a.value}") }.join(" ")
  end

  # Convert component attributes into Ruby keyword args:
  #
  #   label="Store name", placeholder="Become a merchant"
  #   → 'label: "Store name", placeholder: "Become a merchant"'
  #
  def ruby_attributes(node)
    node.attribute_nodes
        .reject { |a| %w[name id].include?(a.name) } # name/id are used to infer field_name; do not emit as kwargs
        .map { |a| ruby_kw_pair(a) }
        .compact
        .join(", ")
  end

  # Single attribute: key="value" -> key: "value"
  def ruby_kw_pair(attr)
    key = ruby_key(attr.name)
    val = ruby_value(attr)
    "#{key}: #{val}"
  end

  # Key normalization: kebab-case -> snake_case; camelCase -> snake_case
  #
  #   "maxLength" / "max-length" → max_length
  #
  def ruby_key(name)
    normalized = name.tr("-", "_").underscore

    return :autocomplete if normalized == "auto_complete"
    return :readonly if normalized == "read_only"

    normalized.to_sym
  end

  # Value normalization: currently treat everything as a string (via `inspect`).
  # Extend here later for booleans/numbers if needed.
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
