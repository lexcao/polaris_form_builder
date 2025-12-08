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

  attr_accessor :title
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
      content.sub(/<input[^>]*type="hidden"[^>]*>/, '')
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
          bundle exec ruby -I test test/test_text_field.rb -n #{method_name} -v
          DOC
        end
      end
    end

    def component_name
      name.delete_prefix("Test")
    end

    def load_examples(component_name)
      ComponentExampleTest.load_examples(component_name)
    end
  end

  def normalize(html)
    html = html.strip
    html = html.gsub(/\sname="[^"]*"/, "")
    html = html.gsub(%r{<(s-[\w:-]+)([^>/]*?)\s*/>}i, '<\1\2></\1>')
    html = Nokogiri::HTML5::DocumentFragment.parse(html).to_html
    html = html.gsub(/\s([a-z0-9:_-]+)="(?:\1)?"/i, ' \1')
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
