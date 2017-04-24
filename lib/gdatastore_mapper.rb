require 'active_support/concern'
require 'active_model'
require 'google/cloud/datastore'

require 'gdatastore_mapper/version'
require 'gdatastore_mapper/session'
require 'gdatastore_mapper/base'

ActiveSupport.on_load(:i18n) do
  I18n.load_path << File.dirname(__FILE__) + "/gdatastore_mapper/locale/en.yml"
end
