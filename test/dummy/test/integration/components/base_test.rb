# frozen_string_literal: true

require "test_helper"

module Components
  class BaseTest < ActionDispatch::IntegrationTest
    def component_get(component)
      get component_path(component)
    end

    def component_post(component, preview_params)
      post submit_component_path(component), params: { preview: preview_params }
    end

    def assert_component(selector, attrs = {})
      assert_select selector_with_attrs(selector, attrs)
    end

    def assert_submit(label)
      assert_select "s-button[type=?][data-disable-with=?]", "submit", label
    end

    private

    def selector_with_attrs(selector, attrs)
      return selector if attrs.empty?

      attr_selector = attrs.map { |key, value| %(#{key}="#{value}") }.join("][")
      %(#{selector}[#{attr_selector}])
    end
  end
end
