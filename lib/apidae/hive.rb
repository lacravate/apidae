# encoding: utf-8

# application code base
require 'apidae/swarm'

# specific requirement for Apidae::Hive
require 'apidae/worker'
require 'apidae/cell'
require 'pathstring_root'

module Apidae

  class Hive < Swarm

    ways_and_means! ways_and_location

    # Hive mapper, construct, population
    set :root_class, PathstringRoot
    set :branching_class, Apidae::Cell

    # Hive population, routes callbacks provider
    include Apidae::Worker

  end

end
