module GdatastoreMapper
  module Persistence

    def save
      return false if !valid?
      run_callbacks :save do
        entity = to_entity
        GdatastoreMapper::Session.dataset.save(entity)
        self.id = entity.key.id
        update_owner(self, :add)
        true
      end
    end

    def update attributes
      return false if !valid?
      run_callbacks :update do
        attributes.each do |name, value|
          send "#{name}=", value if respond_to? "#{name}="
        end
        save
      end
    end

    def destroy
      run_callbacks :destroy do
        update_owner(self, :delete)
        GdatastoreMapper::Session.dataset.delete \
          Google::Cloud::Datastore::Key.new self.class.to_s, id
      end
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
        return unless owner_record = belonging.send(owner)
        existing_ids = owner_record.send(belongings_id) || []
        owner_record.update(owner_attr(belongings_id, existing_ids, flg))
      end
    end

    def owner_attr belongings_id, existing_ids, flg
      owner_attr = {}
      if flg == :add
        existing_ids << self.id
      elsif flg == :delete
        existing_ids.delete(self.id)
      end
      owner_attr[belongings_id] = (existing_ids.uniq)
      owner_attr
    end

  end
end
