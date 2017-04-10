require "google/cloud/datastore"
require "gdatastore_mapper/session"
require "gdatastore_mapper/scoping"
require "gdatastore_mapper/associations"
require "gdatastore_mapper/persistence"

module GdatastoreMapper
  module Base
    extend ActiveSupport::Concern
    include ActiveModel::Model
    include ActiveModel::Validations

    attr_accessor :id, :created_at, :updated_at

    def self.included(klass)
      klass.extend Scoping
      klass.extend Associations
      klass.include Persistence
    end

    module ClassMethods

      def attr_accessor(*vars)
        @attributes ||= []
        @attributes.concat vars
        super
      end

      def attributes
        @attributes.reject do |attr|
          [:id, :created_at, :updated_at].include? attr
        end
      end

      def from_entity entity
        record = self.new
        record.id = entity.key.id
        entity.properties.to_hash.each do |name, value|
          record.send "#{name}=", value if record.respond_to? "#{name}="
        end
        record
      end

      def create params
        record = self.new params
        record.save
        record
      end

    end

    def attributes
      self.class.attributes
    end

    def to_entity
      entity = Google::Cloud::Datastore::Entity.new
      entity.key = Google::Cloud::Datastore::Key.new self.class.to_s, id

      attributes.each do |attribute|
        entity[attribute] = self.send attribute if self.send attribute
      end

      entity['created_at'] = id ? self.created_at : Time.zone.now
      entity["updated_at"] = Time.zone.now
      entity
    end

  end
end
