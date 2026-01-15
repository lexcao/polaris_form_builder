# frozen_string_literal: true

class LandingPreview
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :title, :string
  attribute :description, :string
  attribute :status, :string
  attribute :featured, :boolean

  def as_json(*)
    { post: attributes.compact }
  end

  def to_pretty_json
    JSON.pretty_generate(as_json)
  end
end
