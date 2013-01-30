# encoding: utf-8

require 'forwardable'

# Sinatra, the actual star of the show
require 'sinatra/base'

# Sinatra routes from configuration
require 'ways-and-means'

module Apidae

  # the app'. Thanks to "Mr Blue Eyes" talent
  class Hive < Sinatra::Base

    class << self

      attr_accessor :location

      def ways_and_location
        { ways: [ 'browse', 'browse/*', 'show/*', 'read/*' ], means: { location: location } }
      end

      def found_hive
        require 'apidae/worker'
        require 'apidae/cell'
        require 'pathstring_root'

        branching_class, root_class, worker_class = Apidae::Cell, PathstringRoot, Apidae::Worker

        include worker_class
        settings.location = root_class.new(location).tap do |l|
          l.branching_class = branching_class
          l.absolute!
        end
      end

    end

    # Who's populating the hive ?
    if respond_to? :population
      # insects defined in the configuration ?
      require "apidae/#{population}"
    else
      # or the basic generic apidae described in the lib' ?
      Construct, Queen, Population = Apidae::Construct, Apidae::Queen, Apidae::Worker
    end

    # Now we know who's who, where's where and what's what,
    # define the application API and behaviors
    include Construct
    include Queen
    include Population

  end

end
