require 'yaml'

class ConfigMock
  def self.database(config)
    @@dataset_id = config['test']['dataset_id']
    @@emulator = config['test']['emulator_host']
  end

  def self.config
    ConfigMock.new
  end

  def database_configuration
    { "#{Rails.env}" =>  { 'dataset_id' => @@dataset_id, 'emulator_host' => @@emulator } }
  end
end
