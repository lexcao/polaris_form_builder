# frozen_string_literal: true

class PreviewForm
  include ActiveModel::Model

  attr_accessor :component_key, :store_name, :require_a_confirmation_step,
                :quantity, :email, :password, :your_website, :search, :shipping_address

  validates :store_name, presence: true, if: -> { component_key.to_s == "text_field" }
  validates :require_a_confirmation_step, acceptance: true, if: -> { component_key.to_s == "checkbox" }
  validates :quantity, presence: true, if: -> { component_key.to_s == "number_field" }
  validates :quantity, numericality: { greater_than: 0 }, allow_blank: true, if: -> { component_key.to_s == "number_field" }
  validates :email, presence: true, if: -> { component_key.to_s == "email_field" }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true, if: -> { component_key.to_s == "email_field" }
  validates :password, presence: true, if: -> { component_key.to_s == "password_field" }
  validates :password, length: { minimum: 6 }, allow_blank: true, if: -> { component_key.to_s == "password_field" }
  validates :your_website, presence: true, if: -> { component_key.to_s == "url_field" }
  validates :search, presence: true, if: -> { component_key.to_s == "search_field" }
  validates :shipping_address, presence: true, if: -> { component_key.to_s == "text_area" }
end
