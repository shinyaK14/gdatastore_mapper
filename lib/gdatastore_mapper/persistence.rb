require "google/cloud"

module GdatastoreMapper
  module Persistence

    def save
      return false if !valid?
      entity = to_entity
      GdatastoreMapper::Session.dataset.save(entity)
      self.id = entity.key.id
      update_owner(self, :add)
      true
    end

    def update attributes
      attributes.each do |name, value|
        send "#{name}=", value if respond_to? "#{name}="
      end
      save
    end

    def destroy
      update_owner(self, :delete)
      GdatastoreMapper::Session.dataset.delete \
        Google::Cloud::Datastore::Key.new self.class.to_s, id
    end

    def delete
      destroy
    end

    def persisted?
      id.present?
    end

    private

    def update_owner belonging, flg = :add
      return if self.class.belongs_to_models.nil?
      belongings_id = belonging.class.to_s.pluralize.underscore + '_id'
      self.class.belongs_to_models.each do |owner|
        owner_record = belonging.send(owner)
        existing_ids = owner_record.send(belongings_id) || []
        owner_record.update(owner_attr(belongings_id, existing_ids, flg))
      end
    end

    def owner_attr belongings_id, existing_ids, flg
      owner_attr = {}
      if flg == :add
        owner_attr[belongings_id] = (existing_ids << self.id)
      elsif flg == :delete
        existing_ids.delete(self.id)
        owner_attr[belongings_id] = existing_ids
      end
    end

  end
end
