# frozen_string_literal: true

class PreviewForm
  include ActiveModel::Model

  attr_accessor :store_name

  validates :store_name, presence: true
end
