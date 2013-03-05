# encoding: utf-8

# the ubiquitous delegator
require 'forwardable'

# Sinatra, the actual star of the show
require 'sinatra/base'

# Sinatra routes from configuration
require 'ways-and-means'

module Apidae

  module Buidler

    def partial(template, locals={})
      send settings.template_engine, template.to_sym, layout: false, locals: locals
    end

  end

  # the app'. Thanks to "Mr Blue Eyes" talent
  class Swarm < Sinatra::Base

    class << self

      def implant!(options=nil)
        require 'apidae/queen'
        options ? super : super()
      end

      # routes and minimal config
      # location key mainly to an accessor on the swarm after this name
      def ways_and_location
        { ways: [ 'browse', 'browse/*', 'show/*', 'read/*' ], means: { location: '' } }
      end

      private

    end

    include Buidler
    register Sinatra::WaysAndMeans

    extend Forwardable
    def_delegators :location, :branching, :read

    attr_accessor :location, :current

    not_found { not_found }

    def initialize(*args)
      super

      @location = settings.root_class.new((args.first || self.class).location).tap do |l|
        l.branching_class = settings.branching_class if settings.branching_class
        l.absolute!
      end
    end

    private

    # before hook, thanks to ways-and-means, to have the current path available
    # everywhere as `current`
    def before_anyway
      @current = location.select (params.any? && params['splat'].first) || ''
      raise Sinatra::NotFound unless @current.exist?
    end

    def not_found
      if current && !current.exist?
        file_not_found
      else
        super
      end
    end

    def file_not_found
      redirect '/browse' unless @current.exist?
    end

  end

end

