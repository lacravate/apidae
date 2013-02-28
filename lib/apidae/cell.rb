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

    def size
      ['o', 'k', 'G'].inject(super.to_f) do |s, unit|
        if s.is_a?(Float) && s >= 1024
          s = s / 1024
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
