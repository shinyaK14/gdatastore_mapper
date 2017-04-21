module GdatastoreMapper
  module Persistence
    module ClassMethods

      def create params
        record = self.new params
        record.save
        record
      end

      def delete_all
        self.each do |resource|
          resource.destroy
        end
        true
      end

    end
  end
end
