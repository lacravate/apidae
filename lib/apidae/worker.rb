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
        # link to directory root
        # parent link unless current is root
        # page description
        # files list in UL tag
        unless current.absolute == location
          a << (text << link('browse', '', 'Root directory'))
          a << (text << parent_link)
        end

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
          (text << link('browse', '', 'Root directory')) <<
          text(parent_link) <<
          text("#{current.basename} - #{current.size}") <<
          text('-----') <<
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
        link 'read', current, "Link to resource : #{current.basename} - #{current.size}"
      end
    end

    # Sorry what ?
    def parent_link
      link 'browse', current.dirname, 'Parent directory'
    end

    # browse link for directories, show link for files
    def element_link(element)
      (element.file? && link('show', element, "#{element.basename} - #{element.size}")) ||
        link('browse', element, element.basename)
    end

  end

end
