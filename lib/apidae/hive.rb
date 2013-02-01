# encoding: utf-8

# the ubiquitous delegator
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

      # routes and minimal config
      def ways_and_location
        { ways: [ 'browse', 'browse/*', 'show/*', 'read/*' ], means: { location: location } }
      end

      # hybrid heterogeneous method futhering the class definition at run-time
      def found_hive
        # Requirements set here because they will be made optional when the
        # complete Hive subclassing plot will be achieved.
        # Some other class defintion may define other workers or construct, and
        # so forth, these `require` must not be done.
        # In general, i prefer to delay as much class definition as possible
        # until run-time
        require 'apidae/worker'
        require 'apidae/cell'
        require 'pathstring_root'

        # Hive population, architect, construct set with a mere declaration for the time being
        branching_class, root_class, worker_class = Apidae::Cell, PathstringRoot, Apidae::Worker

        # routes callbacks provider
        include worker_class

        # Routes setup
        ways_and_means! ways_and_location

        # document root as a PathringRoot or anything that will retrieve and
        # list files easily
        settings.location = root_class.new(location).tap do |l|
          l.branching_class = branching_class
          l.absolute!
        end
      end

    end

    extend Forwardable
    register Sinatra::WaysAndMeans

    # "settings" is not pretty. And it's less typing. So...
    def_delegators :settings, :location, :found_hive, :current
    def_delegators :location, :branching, :read

    def initialize
      super
      # run-time class definitions
      found_hive
    end

    private

    # before hook, thanks to ways-and-means, to have the current path available
    # everywhere as `current`
    def before_anyway
      settings.current = location.select (params.any? && params['splat'].first) || ''
    end

  end

end
