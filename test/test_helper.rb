# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "polaris_form_builder"

require "minitest/autorun"

require "action_view/test_case"
require "active_model"

module RenderERBUtils
  def render_erb(string)
    @virtual_path = nil

    template = ActionView::Template.new(
      string.strip,
      "TestTemplate",
      ActionView::Template::Handlers::ERB,
      format: :html, locals: []
    )
    self.render(template: template)
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
