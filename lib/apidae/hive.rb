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

    extend Forwardable
    # Routes from configuration. Registering.
    register Sinatra::WaysAndMeans

    # Routes from configuration. Calling
    ways_and_means! ways_and_location

    # "settings" is not pretty. And it's less typing. So...
    def_delegators :settings, :location, :found_hive, :current
    def_delegators :location, :branching, :read

    def initialize
      super
      found_hive
    end

    private

    # before hook, thanks to ways-and-means, to have the current
    # path available everywhere as `current`
    def before_anyway
      settings.current = location.select (params.any? && params['splat'].first) || ''
    end

  end

end
