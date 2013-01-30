# encoding: utf-8

# MIME types... unsatisfactory though
require 'rack/mime'

require 'pathstring'

module Apidae

  class Cell < Pathstring

    attr_reader :mime

    def initialize(*args)
      super
      @mime = Rack::Mime.mime_type extname
    end

    def relative!
      super
      replace '' if self == '.'
    end

    def slashed
      dup.tap { |d| d << '/' unless file? }
    end

  end

end
