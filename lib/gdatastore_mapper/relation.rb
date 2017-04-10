module GdatastoreMapper
  class Relation < Array
    def initialize(klass)
      @klass = klass
    end
  end
end
