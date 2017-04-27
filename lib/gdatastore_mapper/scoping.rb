require "gdatastore_mapper/relation"

module GdatastoreMapper
  module Scoping

    def where condition, &block
      return nil unless condition.is_a?(Hash)
      dataset_run(where_query(condition), &block)
    end

    def find id
      return nil if id.nil?
      query = Google::Cloud::Datastore::Key.new self.to_s, id.to_i
      entities = GdatastoreMapper::Session.dataset.lookup query
      from_entity entities.first if entities.any?
    end

    def find_by condition
      return nil unless condition.is_a?(Hash)
      where(condition)&.first
    end

    def find_or_create condition
      return nil unless condition.is_a?(Hash)
      if record = where(condition)&.first
        record
      else
        create condition
      end
    end

    def order condition, &block
      return nil unless condition.is_a?(Hash)
      dataset_run(order_query(condition), &block)
    end

    def all &block
      order(created_at: :asc, &block)
    end
    alias_method :each, :all

    def first
      all.first
    end

    def last
      all.last
    end

    def count
      all.count
    end

    def limit condition
      return nil unless condition.is_a?(Fixnum)
      all[0..condition-1]
    end

    private

    def where_query condition
      query = Google::Cloud::Datastore::Query.new.kind(self.to_s)
      condition.each do |property, value|
        query.where(property.to_s, '=', value)
      end
      query
    end

    def order_query condition
      query = Google::Cloud::Datastore::Query.new.kind(self.to_s)
      condition.each do |property, value|
        query.order(property.to_s, value)
      end
      query
    end

    def dataset_run query, &block
      entities = GdatastoreMapper::Session.dataset.run query
      result = GdatastoreMapper::Relation.new(self, nil)
      entities.each do |entity|
        record = from_entity(entity)
        block.call(record) if block_given?
        record = find(record.id)
        result << record if record
      end
      result
    end
  end
end
