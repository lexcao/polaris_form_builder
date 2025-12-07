# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "polaris_form_builder"

require "minitest/autorun"
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
    component_name = base.name.delete_prefix("Test")
    metadata = component_metadata(component_name)
    examples = metadata.fetch("examples", [])

    examples.each_with_index do |example, index|
      method_name = example_test_name(example, index)
      base.define_method(method_name) do
        example_name = example.fetch("name", "Example")
        form_with(model: Post.new) do |form|
          concat render_erb(example.fetch("erb_code"), locals: {form: form})
        end

        expected = example.fetch("html_code").strip
        rendered = normalized_rendered_form
        assert_dom_equal expected, rendered, "Example: #{example_name}"
        assert_equal closing_tags(expected), closing_tags(rendered), "Closing tags mismatch for example: #{example_name}"
      end
    end
  end

  def normalized_rendered_form
    form_body(@rendered).gsub(/\sname="[^"]*"/, "")
  end

  def closing_tags(html)
    html.scan(%r{</([a-z0-9\-]+)>}i).flatten
  end

  def self.component_metadata(component_name)
    path = File.expand_path("../data/components/#{component_name}.json", __dir__)
    JSON.load_file(path)
  end

  def self.example_test_name(example, index)
    base_name = example["name"].to_s.strip.downcase
    normalized = base_name.gsub(/[^a-z0-9]+/, "_").gsub(/\A_+|_+\z/, "")
    normalized = "example_#{index + 1}" if normalized.empty?
    "test_example_#{normalized}"
  end
end
