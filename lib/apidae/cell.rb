# encoding: utf-8

# MIME types... unsatisfactory though
require 'rack/mime'

# most of the job is done here :
# A string representing the file path with the most widely used pathname interfaces
require 'pathstring'

module Apidae

  class Cell < Pathstring

    attr_reader :mime

    def initialize(*args)
      super
      @mime = Rack::Mime.mime_type extname
    end

    # We don't want '.' path
    def relative!
      super
      replace '' if self == '.'
    end

    # trailing slash on directories
    def slashed
      dup.tap { |d| d << '/' unless file? }
    end

  end

end
