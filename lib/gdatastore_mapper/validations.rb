require 'gdatastore_mapper/validations/uniqueness_validator'

module GdatastoreMapper
  module Validations
    def validates_uniqueness_of(*args)
      validates_with(UniquenessValidator, _merge_attributes(args))
    end
  end
end
