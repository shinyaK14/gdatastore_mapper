require "google/cloud"

module GdatastoreMapper
  class Session

    def self.dataset
      config = Rails.application.config.database_configuration[Rails.env]
      @dataset ||= Google::Cloud::Datastore.new(
        project: config['dataset_id'],
        emulator_host: config['emulator_host']
      )
    end

    def self.destroy
      @dataset = nil
    end
  end
end
