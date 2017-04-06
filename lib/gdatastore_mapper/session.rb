require "google/cloud"

module GdatastoreMapper
  class Session

    def self.datastore
      config = Rails.application.config.database_configuration[Rails.env]
      @datastore ||= Google::Cloud::Datastore.new(
        project: config['dataset_id'],
        emulator_host: config['emulator_host']
      )
    end

    def self.destroy
      @datastore = nil
    end
  end
end
