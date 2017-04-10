require "google/cloud"

module GdatastoreMapper
  module Persistence

    def save
      return false if !valid?
      entity = to_entity
      GdatastoreMapper::Session.dataset.save(entity)
      self.id = entity.key.id
      true
    end

    def update attributes
      attributes.each do |name, value|
        send "#{name}=", value if respond_to? "#{name}="
      end
      save
    end

    def destroy
      GdatastoreMapper::Session.dataset.delete \
        Google::Cloud::Datastore::Key.new self.class.to_s, id
    end

    def delete
      GdatastoreMapper::Session.dataset.delete \
        Google::Cloud::Datastore::Key.new self.class.to_s, id
    end

    def persisted?
      id.present?
    end
  end
end
