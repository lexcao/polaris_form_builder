# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "polaris_form_builder"

require "minitest/autorun"
require "nokogiri"
require "json"

require "action_view/test_case"
require "active_model"

module RenderERBUtils
  def render_erb(string, locals: {})
    @virtual_path = nil

    template = ActionView::Template.new(
      string.strip,
      "TestTemplate",
      ActionView::Template::Handlers::ERB,
      format: :html,
      locals: locals.keys
    )
    self.render(template: template, locals: locals)
  end
end

class Post
  include ActiveModel::API

  attr_accessor :title, :password, :description, :quantity, :category
end

class TestCase < ActionView::TestCase
  include RenderERBUtils

  tests ActionView::Helpers::FormHelper

  setup do
    self.default_form_builder = PolarisFormBuilder::FormBuilder
    self.default_url_options[:host] = "example.com"
  end

  def form_with(*, **)
    @rendered = super
  end

  def form_body(input)
    if input =~ /<form[^>]*>(.*?)<\/form>/m
      content = $1.strip
      # Remove the first hidden input element
      content.sub(/<input[^>]*type="hidden"[^>]*>/, "")
    else
      input
    end
  end

  def url_for(object)
    @url_for_options = object

    if object.is_a?(Hash) && object[:use_route].blank? && object[:controller].blank?
      object[:controller] = "main"
      object[:action] = "index"
    end

    super
  end

  Routes = ActionDispatch::Routing::RouteSet.new
  Routes.draw do
    resources :posts
    get "/foo", to: "controller#action"
    root to: "main#index"
  end

  include Routes.url_helpers
end

module ComponentExampleTest
  def self.included(base)
    base.extend(ClassMethods)
    base.generate_example_tests
  end

  module ClassMethods
    def generate_example_tests
      component = component_name
      examples = load_examples(component)

      examples.each_with_index do |example, index|
        method_name = ComponentExampleTest.example_test_name(example, index)
        define_method(method_name) do
          example_name = example.fetch("name", "Example")
          form_with(model: Post.new) do |form|
            concat render_erb(example.fetch("erb_code"), locals: { form: form })
          end

          expected = normalize example.fetch("html_code")
          rendered = normalize form_body(@rendered)
          assert_dom_equal expected, rendered, <<~DOC
          Example: #{example_name} failed
            expected: #{expected}
            rendered: #{rendered}

          Re-run with:
          bundle exec ruby -I test test/text_field_test.rb -n #{method_name} -v
          DOC
        end
      end
    end

    def component_name
      name.delete_prefix("Test").delete_suffix("Test")
    end

    def load_examples(component_name)
      ComponentExampleTest.load_examples(component_name)
    end
  end

  def normalize_html(html, ignore_attrs: [], only: nil)
    fragment = Nokogiri::HTML5.fragment(html)
    selector = only || "*"
    fragment.css(selector).each do |node|
      ignore_attrs.each { |attr| node.remove_attribute(attr) }
    end
    fragment.to_html
  end

  def normalize(html)
    # The goal of this helper is "snapshot-style" comparison against the SoT `html_code`,
    # not to validate Rails semantics. Semantic behavior that Rails adds (e.g. the
    # unchecked hidden input for `check_box`) should be asserted in dedicated tests
    # like `test/test_checkbox.rb`.
    html = html.strip

    # Checkbox is a special case:
    # - Rails `check_box` renders an extra unchecked hidden input by default.
    # - Rails also defaults the checked value to "1".
    # The SoT `html_code` examples typically model only the Polaris component tag, so we
    # normalize these Rails-specific artifacts away for the example-driven assertions.
    is_checkbox = html.match?(/<\s*s-checkbox\b/i)

    # The exact `name="..."` is not stable across different form scopes, and most SoT
    # examples are not intended to assert it.
    html = html.gsub(/\sname="[^"]*"/, "")

    # Drop Rails' unchecked hidden input for checkboxes (see `TestCheckbox` for behavior coverage).
    html = html.gsub(/<input\b[^>]*type=(?:"hidden"|'hidden'|hidden)[^>]*>/i, "") if is_checkbox

    # Ensure custom elements are not self-closed so Nokogiri doesn't change structure.
    html = html.gsub(%r{<(s-[\w:-]+)([^>/]*?)\s*/>}i, '<\1\2></\1>')

    # Canonicalize HTML (attribute order/quoting/whitespace) for stable comparisons.
    html = Nokogiri::HTML5::DocumentFragment.parse(html).to_html

    # The checkbox default `value="1"` is a Rails detail; SoT examples commonly omit it.
    html = html.gsub(/(<s-checkbox\b[^>]*?)\svalue="1"/i, '\1') if is_checkbox

    # Normalize boolean attributes: `checked="checked"` => `checked`.
    html = html.gsub(/\s([a-z0-9:_-]+)="(?:\1)?"/i, ' \1')

    # Normalize type attribute for consistency. Example: remove "type"="text" from <input>
    html = normalize_html(html, ignore_attrs: %w[type])

    html
  end

  def self.component_metadata(component_name)
    path = File.expand_path("../data/components/#{component_name}.json", __dir__)
    JSON.parse(File.read(path))
  end

  def self.load_examples(component_name)
    metadata = component_metadata(component_name)
    metadata.fetch("examples", [])
  end

  def self.example_test_name(example, index)
    base_name = example["name"].to_s.strip.downcase
    normalized = base_name.gsub(/[^a-z0-9]+/, "_").gsub(/\A_+|_+\z/, "")
    normalized = "example_#{index + 1}" if normalized.empty?
    "test_example_#{normalized}"
  end
end
