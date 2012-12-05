# encoding: utf-8

require 'rack/test'

require File.expand_path('../../lib/apidae.rb', __FILE__)

RSpec.configure do |config|
  # config from --init
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'

  # Apidae::Hive application testing
  config.include Rack::Test::Methods
end

# Overloading class definition
#  - ways_and_means to manually configure application routes
#  - definition of the application root directory as Pathname (as
#    it is done in the vanilla definition)

# TODO: get rid off of that as soon as ways_and_means accepts
# an alternative configuration file
class Apidae::Hive

  ways_and_means! location: '.', ways: {
    browse: 'row',
    'browse/*' => 'row',
    'show/*' => 'cell',
    'media/*' => 'honey'
  }

  # will browse and show files from that directory
  # i.e. the gem source directory
  self.location = Pathname(location).realpath
  
end
