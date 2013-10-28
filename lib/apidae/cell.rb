# encoding: utf-8

# MIME types... unsatisfactory though
require 'rack/mime'

# most of the job is done here with this require
require 'pathstring'

module Apidae

  class Cell < Pathstring

    attr_reader :mime

    def initialize(*args)
      super
      @mime = Rack::Mime.mime_type extname
    end

    # We don't want '.' path
    # dunno if it's a good idea
    def relative!
      super
      replace '' if self == '.'
    end

    # classic human readable size with classic size units
    def size
      ['o', 'k', 'G'].inject(super.to_f) do |s, unit|
        # recusively divide by 1024 until...
        if s.is_a?(Float) && s >= 1024
          s = s / 1024
        # we format it here with the unit
        elsif !s.is_a?(String)
          s = "#{s.to_s.gsub(/(\.\d{3})\d+$/, "\\1")} #{unit}"
        end
        s
      end
    end

    # trailing slash on directories
    def slashed
      dup.tap { |d| d << '/' unless file? }
    end

  end

end
