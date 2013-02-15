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

      def implant!(options=nil)
        require 'apidae/queen'
        options ? super : super()
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

