# encoding: utf-8

# Minimal CLI
require 'getopt/long'

module Apidae

  # The Swarm needs to "include" a Queen to implant a Hive
  module Queen

    def implant!(options=environment)
      # Need help ?
      if ['help', 'h'].any? { |o| options.has_key? o }
        puts etiquette
      else
        # set the root directory, current directory as default, and go!
        settings.location = options.delete('browse') { '.' }
        run! options
      end
    end

    # what we got from CLI
    def environment
      @environment ||= Getopt::Long.getopts(
        ['--help', Getopt::OPTIONAL],
        ['--server', Getopt::OPTIONAL],
        ['--port', Getopt::OPTIONAL],
        ['--daemonize', Getopt::OPTIONAL],
        ['--browse', Getopt::OPTIONAL]
      )
    end

    # the way things should be
    def etiquette
      "Usage : #{charmer} [--server <server_name> --port <port_number> --daemonize --browse </path/to/browse>]"
    end

    # the charmer unites the queen to the swarm
    def charmer
      @charmer ||= self.name.split('::').first.downcase
    end

  end

  # class definition is never closed in ruby
  # module extension runtime, then
  class Swarm; extend Queen; end

end
