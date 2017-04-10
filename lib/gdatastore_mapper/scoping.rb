require "google/cloud"
require "gdatastore_mapper/relation"

module GdatastoreMapper
  module Scoping

    def where condition
      return nil unless condition.is_a?(Hash)
      entities = dataset_run(where_query condition)
    end

    def find id
      return nil unless id.is_a?(Fixnum)
      query = Google::Cloud::Datastore::Key.new self.to_s, id.to_i
      entities = GdatastoreMapper::Session.dataset.lookup query
      from_entity entities.first if entities.any?
    end

    def find_by condition
      return nil unless condition.is_a?(Hash)
      where(condition)&.first
    end

    def order condition
      return nil unless condition.is_a?(Hash)
      dataset_run(order_query condition)
    end

    private

    def where_query condition
      query = Google::Cloud::Datastore::Query.new
      query.kind self.to_s
      condition.each do |property, value|
        query.where(property.to_s, '=', value)
      end
      query
    end

    def order_query condition
      query = Google::Cloud::Datastore::Query.new
      query.kind self.to_s
      condition.each do |property, value|
        query.order(property.to_s, value)
      end
      query
    end

    def dataset_run query
      entities = GdatastoreMapper::Session.dataset.run query
      result = GdatastoreMapper::Relation.new(self)
      entities.each do |entity|
        result << (from_entity entity)
      end
      result
    end
  end
end
