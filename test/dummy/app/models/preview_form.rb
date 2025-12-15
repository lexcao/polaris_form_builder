# frozen_string_literal: true

class PreviewForm
  include ActiveModel::Model

  attr_accessor :component_key, :store_name, :require_a_confirmation_step

  validates :store_name, presence: true, if: -> { component_key.to_s == "text_field" }
  validates :require_a_confirmation_step, acceptance: true, if: -> { component_key.to_s == "checkbox" }
end
