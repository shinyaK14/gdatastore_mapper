module GdatastoreMapper
  module Associations
    class HasMany

      attr_accessor :owner, :belonging

      def initialize(owner, belonging)
        @owner = owner
        @belonging = belonging
      end

      def belonging_klass
        @belonging.to_s.classify.constantize
      end

      def owner_attributes
        {
          (@owner.class.to_s.underscore + '_id') => @owner.id
        }
      end

      def belonging_id
        @belonging.to_s + '_id'
      end
    end
  end
end

