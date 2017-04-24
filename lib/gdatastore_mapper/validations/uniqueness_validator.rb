module GdatastoreMapper
  module Validations
    class UniquenessValidator < ActiveModel::EachValidator # :nodoc:
      def initialize(options)
        if options[:conditions] && !options[:conditions].respond_to?(:call)
          raise ArgumentError, "#{options[:conditions]} was passed as :conditions but is not callable. " \
                               "Pass a callable instead: `conditions: -> { where(approved: true) }`"
        end
        super({ case_sensitive: true }.merge!(options))
        @klass = options[:class]
      end

      def validate_each(record, attribute, value)
        finder_class = find_finder_class_for(record).first
        # value = map_enum_attribute(finder_class, attribute, value)

        relation = build_relation(finder_class, attribute, value)
        if record.persisted?
          relation = detect_relation(relation, record.id)
          # if finder_class.primary_key
          #   relation = relation.where.not(finder_class.primary_key => record.id_in_database || record.id)
          # else
          #   raise UnknownPrimaryKey.new(finder_class, "Can not validate uniqueness for persisted record without primary key.")
          # end
        end
        relation = scope_relation(record, relation)
        relation = relation.merge(options[:conditions]) if options[:conditions]

        if relation.present?
          error_options = options.except(:case_sensitive, :scope, :conditions)
          error_options[:value] = value

          record.errors.add(attribute, :taken, error_options)
        end
      end

    private
      def find_finder_class_for(record)
        class_hierarchy = [record.class]

        while class_hierarchy.first != @klass
          class_hierarchy.unshift(class_hierarchy.first.superclass)
        end

        # class_hierarchy.detect { |klass| !klass.abstract_class? }
        class_hierarchy
      end

      def build_relation(klass, attribute, value)
        # klass.unscoped.where!({ attribute => value }, options)
        klass.where({ attribute => value })
      end

      def scope_relation(record, relation)
        Array(options[:scope]).each do |scope_item|
          scope_value = if record.class._reflect_on_association(scope_item)
            record.association(scope_item).reader
          else
            record._read_attribute(scope_item)
          end
          relation = relation.where(scope_item => scope_value)
        end

        relation
      end

      def map_enum_attribute(klass, attribute, value)
        mapping = klass.defined_enums[attribute.to_s]
        value = mapping[value] if value && mapping
        value
      end

      def detect_relation(records, id)
        records.select do |record|
          record.id != id
        end
      end
    end

    module ClassMethods
      def validates_uniqueness_of(*attr_names)
        validates_with UniquenessValidator, _merge_attributes(attr_names)
      end
    end
  end
end

