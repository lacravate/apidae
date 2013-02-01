# encoding: utf-8

require 'apidae/wax'

module Apidae

  # This module has the responsibilty to answer the routes callbacks.
  # Methods are no more than templates.
  module Worker

    # ludicrously naive HTML formatting
    include Wax

    # directories
    def browse
      # layout with title and style
      assemblage do |a|
        # parent link unless current is root
        # page description
        # files list in UL tag
        a << (text << parent_link) unless current.absolute == location
        a << text("Contents of \"#{current.slashed}\" :")
        a << list do |l|
          branching.each { |e| l << (listitem << element_link(e)) }
        end
      end
    end

    def show
      # layout with title and style
      assemblage do |a|
        # File name
        # parent link
        # content output as we can contrive
        a <<
         text(current.basename) <<
         text(parent_link) <<
         content
      end
    end

    private

    def assemblage
      # layout with title and style
      super.tap do |a|
        a.title << current.slashed
        a.head << style
      end
    end

    # define a HTML rendering according to file MIME type
    def content
      # img tag
      if current.mime.start_with?('image')
        image current
      # pre section with file contents
      elsif current.mime.start_with?('text')
        formated current.read
      # link to download
      else
        link 'read', current, "Download #{current.basename} here"
      end
    end

    # Sorry what ?
    def parent_link
      link 'browse', current.dirname, 'Parent directory'
    end

    # browse link for directories, show link for files
    def element_link(element)
      (element.file? && link('show', element, element.basename)) ||
        link('browse', element, element.basename)
    end

  end

end
