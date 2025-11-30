# frozen_string_literal: true

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

  attribute :name, :string
  attribute :properties, Property.to_array_type
  attribute :examples, Example.to_array_type

  def metadata=(metadata)
    # skip for now
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

