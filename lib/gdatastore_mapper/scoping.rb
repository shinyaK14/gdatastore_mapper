require "google/cloud"
require "gdatastore_mapper/relation"

module GdatastoreMapper
  module Scoping

    def where condition
      return nil unless condition.is_a?(Hash)
      dataset_run(where_query condition)
    end

    def find id
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

    def order condition
      return nil unless condition.is_a?(Hash)
      dataset_run(order_query condition)
    end

    def all
      order(created_at: :asc)
    end


    def first
      all.first
    end

    def last
      all.last
    end

    def count
      all.count
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
      result = GdatastoreMapper::Relation.new(self, nil)
      entities.each do |entity|
        result << (from_entity entity)
      end
      result
    end
  end
end
