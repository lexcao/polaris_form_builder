# frozen_string_literal: true

class PreviewForm
  include ActiveModel::Model

  attr_accessor :component_key, :store_name, :require_a_confirmation_step, :shipping_address

  validates :store_name, presence: true, if: -> { component_key.to_s == "text_field" }
  validates :require_a_confirmation_step, acceptance: true, if: -> { component_key.to_s == "checkbox" }
  validates :shipping_address, presence: true, if: -> { component_key.to_s == "text_area" }
end
