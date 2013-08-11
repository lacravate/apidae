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

  module Mapper

    def read
      current.read
    end

  end

  # the app'. Thanks to "Mr Blue Eyes" talent
  class Swarm < Sinatra::Base

    include Buidler
    include Mapper
    register Sinatra::WaysAndMeans

    extend Forwardable
    def_delegators :location, :branching,
                              :leaf_branching,
                              :wire_branching

    attr_accessor :location, :current

    not_found { not_found }

    set :root_url, nil
    set :redirect_on_file_not_found, true
    set :location, nil
    set :branching_class, nil

    def self.implant!(options=nil)
      require 'apidae/queen'
      options ? super : super()
    end

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
      set_path
      set_current
      raise Sinatra::NotFound unless found?
    end

    def after_anyway
      redirect redirection if redirection
    end

    def set_path
      @path = (params['splat'] && params['splat'].first) || ''
    end

    def set_current
      @current = location.select @path
    end

    def redirection(url=nil)
      @redirection = url if url
      @redirection.is_a?(Array) ? send(*@redirection) : @redirection
    end

    def found?
      request.put? || request.post? || @current.exist?
    end

    def not_found
      if settings.root_url && settings.redirect_on_file_not_found && current && !current.exist?
        file_not_found
      else
        super
      end
    end

    def file_not_found
      redirect settings.root_url.is_a?(Array) ? send(*settings.root_url) : settings.root_url
    end

  end

end
