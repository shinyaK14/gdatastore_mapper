module GdatastoreMapper
  module QueryMethods
    extend ActiveSupport::Concern

    def order condition, &block
      unless condition.is_a?(Hash)
        raise ArgumentError, "only Hash are allowed"
      end
      dataset_run(order_query(condition), &block)
    end

    def where condition, &block
      unless condition.is_a?(Hash)
        raise ArgumentError, "only Hash are allowed"
      end
      dataset_run(where_query(condition), &block)
    end

    def find id
      return nil if id.nil?
      query = Google::Cloud::Datastore::Key.new in_class, id.to_i
      entities = GdatastoreMapper::Session.dataset.lookup query
      from_entity entities.first if entities.any?
    end

    def find_by condition
      unless condition.is_a?(Hash)
        raise ArgumentError, "only Hash are allowed"
      end
      where(condition)&.first
    end

    def find_or_create condition
      unless condition.is_a?(Hash)
        raise ArgumentError, "only Hash are allowed"
      end
      if record = where(condition)&.first
        record
      else
        create condition
      end
    end

    def limit condition
      unless condition.is_a?(Fixnum)
        raise ArgumentError, "only Fixnum are allowed"
      end
      self[0..condition-1]
    end

    private

    def in_class
      self&.first&.class&.to_s
    end

    def order_query condition
      self.query ||= Google::Cloud::Datastore::Query.new.kind(in_class)
      condition.each do |property, value|
        self.query.order(property.to_s, value)
      end
      self.query
    end

    def where_query condition
      self.query ||= Google::Cloud::Datastore::Query.new.kind(in_class)
      condition.each do |property, value|
        self.query.where(property.to_s, '=', value)
      end
      self.query
    end

    def dataset_run query, &block
      entities = GdatastoreMapper::Session.dataset.run query
      result = GdatastoreMapper::Relation.new(in_class, self.association)
      entities.each do |entity|
        record = from_entity(entity)
        block.call(record) if block_given?
        result << record if record
      end
      result.query = query
      result
    end

    def from_entity entity
      record = self.first.class.new
      record.id = entity.key.id
      entity.properties.to_hash.each do |name, value|
        record.send "#{name}=", value if record.respond_to? "#{name}="
      end
      record
    end
  end
end
