# encoding: utf-8

# the ubiquitous delegator
require 'forwardable'

# Sinatra, the actual star of the show
require 'sinatra/base'

# Sinatra routes from configuration
require 'ways-and-means'

module Apidae

  # a type of bee
  module Buidler

    # yeah yeah buddy, i saw the Sinatra contrib'
    # but i didn't understand why it looked so complicated
    # So for now, i'll use my simple version
    def partial(template, locals={})
      send settings.template_engine, template.to_sym, layout: false, locals: locals
    end

  end

  # module ? What about the Worker ?
  # Worker methods are templates
  # this is not. So i put it here.
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

    # what we do when Sinatra says it does not know what you are talking about
    not_found { not_found }

    # basic settings defaults
    set :root_url, nil
    set :redirect_on_file_not_found, true
    set :location, nil
    set :branching_class, nil

    # a bizarre way to make a delegation
    # created runtime
    # or something like that... Bizarre but fun...
    def self.implant!(options=nil)
      # runtime require because i foresaw when i did that
      # that some swarm would remain queenless
      # And it happened...!
      require 'apidae/queen'
      options ? super : super()
    end

    def initialize(*args)
      # Let Franky do his job, will you...
      super

      # document root as one of the PathstringRoot kindred
      @location = settings.root_class.new((args.first || self.class).location).tap do |l|
        l.branching_class = settings.branching_class if settings.branching_class
        l.absolute! # absolute face
      end
    end

    private

    # before hook, thanks to ways-and-means, to have the current path available
    # everywhere as `current`
    def before_anyway
      set_path
      set_current
      # allows us to extend the definition of non-existence
      raise Sinatra::NotFound unless found?
    end

    # the application job in a module, the HTTP-only related jobs here, is a
    # way to make the latter unobstrusive
    def after_anyway
      redirect redirection if redirection
    end

    # current resource path
    def set_path
      @path = (params['splat'] && params['splat'].first) || ''
    end

    # current resource
    def set_current
      @current = location.select @path
    end

    # memoizing redirection parameters to use them unobstrusively
    def redirection(url=nil)
      @redirection = url if url
      @redirection.is_a?(Array) ? send(*@redirection) : @redirection
    end

    # according to apidae, what will be found and what won't
    def found?
      request.put? || request.post? || @current.exist?
    end

    # so, either we have an url to send you back to, or we let papa Franky deal
    # with you
    def not_found
      if settings.root_url && settings.redirect_on_file_not_found && current && !current.exist?
        file_not_found
      else
        super
      end
    end

    # the actual action done when all the conditions are met
    def file_not_found
      redirect settings.root_url.is_a?(Array) ? send(*settings.root_url) : settings.root_url
    end

  end

end
