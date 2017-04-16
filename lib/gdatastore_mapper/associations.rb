# encoding: utf-8
require "google/cloud"
require "gdatastore_mapper/relation"
require "gdatastore_mapper/associations/has_many"

module GdatastoreMapper
  module Associations
    extend ActiveSupport::Concern

    def self.included(klass)
      klass.include Associations
    end

    def has_many models
      self.class_eval("attr_accessor :#{models.to_s + '_id'}")

      define_method models do
        association = GdatastoreMapper::Associations::HasMany.new(self, models)
        belongings = GdatastoreMapper::Relation.new(self, association)
        if self.attributes.include?(id_ models) && !self.send(id_ models).nil?
          self.send(id_ models).each do |id|
            belongings << (models.to_s.classify.constantize.find id)
          end
        end
        belongings
      end
    end

    def belongs_to model
      if @belongs_to_models.nil?
        @belongs_to_models = [model.to_s]
      else
        @belongs_to_models << model.to_s
      end
      self.class_eval("attr_accessor :#{model.to_s + '_id'}")

      define_method model do
        if self.attributes.include?(id_ model)
          model.to_s.classify.constantize.find self.send(id_ model)
        end
      end
    end

    def belongs_to_models
      @belongs_to_models
    end

  end
end
