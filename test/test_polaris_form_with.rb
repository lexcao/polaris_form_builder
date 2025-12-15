# frozen_string_literal: true

require 'test_helper'
require 'polaris_form_builder/helpers'

class TestPolarisFormWith < TestCase
  include PolarisFormBuilder::Helpers

  def test_polaris_form_with_overrides_default_builder
    self.default_form_builder = ActionView::Helpers::FormBuilder

    polaris_form_with(model: Post.new) do |form|
      concat form.check_box(:published, label: 'Published')
      concat form.submit('Save')
    end

    fragment = Nokogiri::HTML5::DocumentFragment.parse(form_body(@rendered))

    assert_equal 1, fragment.css('s-checkbox[label="Published"]').size
    assert_equal 1, fragment.css('s-button[type="submit"]').size
    assert_equal 0, fragment.css('input[type="checkbox"]').size
  end
end
