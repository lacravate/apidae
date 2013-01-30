# encoding: utf-8

require 'rack/test'

require File.expand_path('../../lib/apidae.rb', __FILE__)

# will browse and show files from that directory
# i.e. the gem source directory
Apidae::Hive.location = Dir.pwd

RSpec.configure do |config|
  # config from --init
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'

  # Apidae::Hive application testing
  config.include Rack::Test::Methods
end
