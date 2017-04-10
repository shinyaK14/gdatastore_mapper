require 'yaml'

class ConfigMock
  def self.database(config)
    @@dataset_id = config['test']['dataset_id']
  end

  def self.config
    ConfigMock.new
  end

  def database_configuration
    { "#{Rails.env}" =>  { 'dataset_id' => @@dataset_id, 'emulator_host' => 'localhost:8444'}}
  end
end
