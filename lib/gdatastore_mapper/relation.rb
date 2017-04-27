require 'gdatastore_mapper/relation/query_methods'

module GdatastoreMapper
  class Relation < Array
    include QueryMethods

    attr_accessor :klass, :association

    def initialize(klass, association)
      @klass = klass
      @association = association
    end

    def new attributes
      belonging_attr = attributes.merge(@association.owner_attributes)
      @association.belonging_klass.new(belonging_attr)
    end

    def create attributes
      belonging = create_belonging attributes
      update_owner belonging
      belonging
    end

    private

    def create_belonging attributes
      belonging_attr = attributes.merge(@association.owner_attributes)
      @association.belonging_klass.create(belonging_attr)
    end

    def update_owner belonging
      existing_ids = @association.owner.send(@association.belonging_id)
      existing_ids = [] if existing_ids.nil?
      owner_attr = {}
      owner_attr[@association.belonging_id] = (existing_ids << belonging.id)
      @association.owner.update(owner_attr)
    end

  end
end
