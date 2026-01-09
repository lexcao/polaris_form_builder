# frozen_string_literal: true

class Preview
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :store_name, :string
  attribute :require_a_confirmation_step, :boolean
  attribute :quantity, :string
  attribute :email, :string
  attribute :password, :string
  attribute :your_website, :string
  attribute :search, :string
  attribute :shipping_address, :string
  attribute :date_range, :string

  def as_json(*)
    attributes.compact
  end

  def to_pretty_json
    JSON.pretty_generate(as_json)
  end
end
