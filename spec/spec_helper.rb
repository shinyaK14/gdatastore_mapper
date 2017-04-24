MODELS = File.join(File.dirname(__FILE__), 'app/models')
$LOAD_PATH.unshift(MODELS)

require 'gdatastore_mapper'
require 'bundler/setup'
require 'pry'
require 'rails'
require 'active_model'
require 'active_support/core_ext/string/zones'
require 'active_support/time_with_zone'

Time.zone = 'UTC'

Dir[ File.join(MODELS, '*.rb') ].sort.each do |file|
  name = File.basename(file, '.rb')
  autoload name.camelize.to_sym, name
end

configs = YAML.load_file('spec/config/database.yml')
ConfigMock.database(configs)

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before do
    allow(Rails).to receive(:application).and_return(ConfigMock)
    Author.delete_all
    Book.delete_all
  end
end

