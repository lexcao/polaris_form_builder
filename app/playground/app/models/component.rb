# frozen_string_literal: true

class SourceUrl
  include StoreModel::Model

  attribute :html, :string
end

class MetaData
  include StoreModel::Model

  attribute :title, :string
  attribute :description, :string
  attribute :source_url, SourceUrl.to_type
end

class Property
  include StoreModel::Model

  attribute :key, :string
  attribute :type, :string
  attribute :default, :string
  attribute :description, :string
end

class Example
  include StoreModel::Model

  attribute :name, :string
  attribute :description, :string

  attribute :erb_code, :string
end

class Component
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :metadata, MetaData.to_type
  attribute :properties, Property.to_array_type, default: []
  attribute :examples, Example.to_array_type, default: []

  delegate :description, to: :metadata

  def main_example
    attributes["examples"]&.first
  end

  def examples
    super.drop(1).reject do
      it.description.blank? || it.erb_code.blank?
    end
  end

  def name
    metadata.title
  end

  def to_param
    name.parameterize
  end

  def persisted?
    true
  end

  class << self
    def all
      @all ||= ComponentLoader.load_json
    end

    def find(name)
      all.find { it.name.downcase == name.downcase }
    end
  end
end

