# encoding: utf-8

# the ubiquitous delegator
require 'forwardable'

# Sinatra, the actual star of the show
require 'sinatra/base'

# Sinatra routes from configuration
require 'ways-and-means'

module Apidae

  # the app'. Thanks to "Mr Blue Eyes" talent
  class Swarm < Sinatra::Base

    class << self

      attr_accessor :location, :current

      def implant!
        require 'apidae/queen'
        super
      end

      # routes and minimal config
      def ways_and_location
        { ways: [ 'browse', 'browse/*', 'show/*', 'read/*' ], means: { location: location } }
      end

      private

    end

    extend Forwardable
    register Sinatra::WaysAndMeans

    ways_and_means! ways_and_location

    # "settings" is not pretty. And it's less typing. So...
    def_delegators :settings, :current
    def_delegators :location, :branching, :read

    attr_accessor :location

    def initialize
      super

      @location = settings.root_class.new(settings.location).tap do |l|
        l.branching_class = settings.branching_class if settings.branching_class
        l.absolute!
      end
    end

    private

    # before hook, thanks to ways-and-means, to have the current path available
    # everywhere as `current`
    def before_anyway
      settings.current = location.select (params.any? && params['splat'].first) || ''
    end

  end

end

require 'apidae/worker'
require 'apidae/cell'
require 'pathstring_root'

module Apidae

  class Hive < Swarm

    # Hive mapper, construct, population
    set :root_class, PathstringRoot
    set :branching_class, Apidae::Cell

    # routes callbacks provider
    include Apidae::Worker

  end

end
