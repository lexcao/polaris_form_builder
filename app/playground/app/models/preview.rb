# frozen_string_literal: true

class Preview
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :store_name, :string
  attribute :require_a_confirmation_step, :boolean

  def as_json(*)
    attributes.compact
  end

  def to_pretty_json
    JSON.pretty_generate(as_json)
  end
end
