# encoding: utf-8

# Libraries API best bud !
require 'forwardable'

module Apidae

  # Do i need more ? We'll see.
  class HiveImplationException < Exception; end

  # the app'. Thanks to Mr Blue_eyes talent
  class Hive < Sinatra::Base

    # Libraries API best bud !
    # i am old but i haven't reached dotage yet.
    # I just like to repeat myself.
    extend Forwardable

    # less code
    # and "settings" is not pretty. So...
    def_delegators :settings, :location, :population

    # Routes from configuration. Registering and calling
    register Sinatra::WaysAndMeans
    ways_and_means!

    # clumsy and tasteless, i must change that
    if respond_to? :location
      # we'll browse filesystem from this directory
      # set as a Pathname
      self.location = Pathname(location).realpath
    else
      raise HiveImplationError, "Sorry, dude, the hive can be implanted on nil (set location to anything in conf')"
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
