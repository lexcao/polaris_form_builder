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
  attribute :code, :string
  attribute :description, :string
end

class Component
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :metadata, MetaData.to_type
  attribute :properties, Property.to_array_type
  attribute :examples, Example.to_array_type

  delegate :description, to: :metadata

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
      item = all.find { |component| component.name.downcase == name.downcase }
      puts "find? #{item.inspect}"
      item
    end
  end

end

