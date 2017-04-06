require "google/cloud/datastore"
require "gdatastore_mapper/session"

module GdatastoreMapper
  module Base
    extend ActiveSupport::Concern
    include ActiveModel::Model
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

      def query options = {}
        query = Google::Cloud::Datastore::Query.new
        query.kind self.to_s
        query.limit options[:limit]   if options[:limit]
        query.cursor options[:cursor] if options[:cursor]

        results = dataset.run query
        records   = results.map {|entity| self.from_entity entity }

        if options[:limit] && results.size == options[:limit]
          next_cursor = results.cursor
        end

        return records, next_cursor
      end

      def from_entity entity
        record = self.new
        record.id = entity.key.id
        entity.properties.to_hash.each do |name, value|
          record.send "#{name}=", value if record.respond_to? "#{name}="
        end
        record
      end

      def find id
        query    = Google::Cloud::Datastore::Key.new self.to_s, id.to_i
        entities = GdatastoreMapper::Session.dataset.lookup query

        from_entity entities.first if entities.any?
      end

    end # end pf ClassMethods

    def attributes
      self.class.attributes
    end

    def save
      return false if !valid?
      entity = to_entity
      GdatastoreMapper::Session.dataset.save(entity)
      self.id = entity.key.id
      true
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

    def update attributes
      attributes.each do |name, value|
        send "#{name}=", value if respond_to? "#{name}="
      end
      save
    end

    def destroy
      self.class.dataset.delete Google::Cloud::Datastore::Key.new self.class.to_s, id
    end

    def persisted?
      id.present?
    end
  end
end
