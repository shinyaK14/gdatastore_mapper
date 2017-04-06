require "google/cloud/datastore"
require "gdatastore_mapper/session"

module GdatastoreMapper
  module Base
    extend ActiveSupport::Concern
    include ActiveModel::Validations

    attr_accessor :id, :created_at, :updated_at

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
    end # end pf ClassMethods

    def attributes
      self.class.attributes
    end

    def save
      if valid?
        entity = to_entity
        GdatastoreMapper::Session.datastore.save(entity)
        self.id = entity.key.id
        true
      else
        false
      end
    end

    def to_entity
      entity = Google::Cloud::Datastore::Entity.new
      entity.key = Google::Cloud::Datastore::Key.new self.class.to_s, id

      attributes.each do |attribute|
        entity[attribute] = self.send attribute if self.send attribute
      end

      entity['created_at'] = id ? self.created_at : Time.zone.now
      entity["updated_at"]  = Time.zone.now
      entity
    end

  end
end
