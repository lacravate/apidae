# encoding: utf-8

# $LOAD_PATH upgrade
$:.unshift File.expand_path('../lib', __FILE__)

# utils from stdlib
require 'pathname'
require 'base64'

# Sinatra, the actual star of the show
require 'sinatra/base'

# Sinatra routes from configuration
require 'ways_and_means'

# apidae libs
require 'apidae/apidae'
require 'apidae/hive'
require 'apidae/wax'
require 'apidae/wax/assemblage'

# Modules and classes to define some
# "sort off" architecture and avoid a
# disgraceful "const_set" fest
module Apidae
  class Hive
    module Construct;  end
    module Queen;      end
    module Population; end
  end
end
