require 'gdatastore_mapper/session'
require 'gdatastore_mapper/scoping'
require 'gdatastore_mapper/associations'
require 'gdatastore_mapper/persistence'
require 'gdatastore_mapper/persistence/class_methods'
require 'gdatastore_mapper/validations'

module GdatastoreMapper
  module Base
    extend ActiveSupport::Concern
    include ActiveModel::Model
    include ActiveModel::Validations
    include ActiveModel::Validations::Callbacks
    include ActiveModel::Callbacks

    attr_accessor :id, :created_at, :updated_at

    included do
      define_model_callbacks :save, :update, :destroy
      extend Scoping
      extend Associations
      include Persistence
      extend Persistence::ClassMethods
      extend Validations
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

    end

    def attributes
      self.class.attributes
    end

    def to_entity
      entity_timestamp
      attributes.each do |attribute|
        @entity[attribute] = self.send attribute if self.send attribute
      end
      @entity
    end

    private

    def entity_timestamp
      @entity = Google::Cloud::Datastore::Entity.new
      @entity.key = Google::Cloud::Datastore::Key.new self.class.to_s, id
      @entity['created_at'] = id ? self.created_at : Time.zone.now
      @entity['updated_at'] = Time.zone.now
    end

    def id_ model
      (model.to_s + '_id').to_sym
    end
  end
end
