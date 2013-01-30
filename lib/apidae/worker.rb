# encoding: utf-8

require 'apidae/wax'

module Apidae

  module Worker

    include Wax

    def browse
      assemblage do |a|
        a << (text << parent_link) unless current.absolute == location # unless current is root
        a << text("Contents of \"#{current.slashed}\" :")
        a << list do |l|
          branching.each { |e| l << (listitem << element_link(e)) }
        end
      end
    end

    def show
      assemblage do |a|
        a <<
         text(current.basename) <<
         text(parent_link) <<
         content
      end
    end

    private

    def assemblage
      super.tap do |a|
        a.title << current.slashed
        a.head << style
      end
    end

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

    def parent_link
      link 'browse', current.dirname, 'Parent directory'
    end

    def element_link(element)
      (element.file? && link('show', element, element.basename)) ||
        link('browse', element, element.basename)
    end

  end

end
