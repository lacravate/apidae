# encoding: utf-8

require 'forwardable'

# Sinatra, the actual star of the show
require 'sinatra/base'

# Sinatra routes from configuration
require 'ways-and-means'

module Apidae

  # the app'. Thanks to "Mr Blue Eyes" talent
  class Hive < Sinatra::Base

    # Libraries API best bud !
    # i am old but i haven't reached dotage yet.
    # I just like to repeat myself.
    extend Forwardable

    # less code
    # and "settings" is not pretty. So...
    def_delegators :settings, :location, :population

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
