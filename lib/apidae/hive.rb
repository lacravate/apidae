# encoding: utf-8

# application code base
require 'apidae/swarm'

# specific requirement for Apidae::Hive
require 'apidae/worker'
require 'apidae/cell'
require 'pathstring_root'

module Apidae

  class Hive < Swarm

    # Hive population, routes callbacks provider
    include Apidae::Worker

    # routes and minimal config
    # means keys mainly to set accessors
    ways_and_means! ways:  [ 'browse', 'browse/*', 'show/*', 'read/*' ],
                    means: { location: '' }

    # Hive mapper, construct, population
    set :root_class, PathstringRoot
    set :branching_class, Apidae::Cell

    set :root_url, '/browse'

  end

end
