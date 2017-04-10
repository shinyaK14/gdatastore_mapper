require "google/cloud"

module GdatastoreMapper
  module Associations

    def has_many models

    end

    def belongs_to model
      # if @belongs_to_mode.defined?
      @belongs = model

      define_method @belongs do
        p 'succseed'
      end
    end

  end
end
