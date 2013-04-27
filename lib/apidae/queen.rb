# encoding: utf-8

# Minimal CLI
require 'getopt/long'

module Apidae

  module Queen

    attr_writer :charmer

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

    def environment
      @environment ||= Getopt::Long.getopts(
        ['--help', Getopt::OPTIONAL],
        ['--server', Getopt::OPTIONAL],
        ['--port', Getopt::OPTIONAL],
        ['--daemonize', Getopt::OPTIONAL],
        ['--browse', Getopt::OPTIONAL]
      )
    end

    def etiquette
      "Usage : #{charmer} [--server <server_name> --port <port_number> --daemonize --browse </path/to/browse>]"
    end

    def charmer
      @charmer ||= self.name.split('::').first.downcase
    end

  end

  class Swarm; extend Queen; end

end

