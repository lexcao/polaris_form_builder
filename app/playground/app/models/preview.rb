# frozen_string_literal: true

class Preview
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
end
