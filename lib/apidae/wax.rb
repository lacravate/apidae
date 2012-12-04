# encoding: utf-8

# i love to make people laugh. Myself to begin with, but everyone
# I can't do anything against that. So here we go...

# Raw constructs turned into html elements

# It all started because i did not want to make use of any templating
# system for this minimal application, and because i also didn't want at
# all to bother about template files in the project.

# I only wanted to be able to handle this part of the application with a
# neat Ruby 'require'

module Apidae

  # i know wax is the fabric primarily used by the honey bees and not
  # forcibly, if not at all, by the other apidae. But it sounded cooler
  # and shorter
  module Wax

    # so here, one method per HTML element
    # template element is a base64-encoded string
    # decoded, on which substitutions are made
    # Giggles !
    class << self

      # img src = ...
      def image(source)
        (@image ||= Base64.
          decode64("PGltZyBzcmM9Ii9tZWRpYS8iPg==\n")).
          gsub '/"', "/#{source}\""
      end

      # a href = /action/path , text of the link
      def link(action, path, text)
        (@link ||= Base64.
          decode64("PGEgaHJlZj0iLy8iPjwvYT4=\n")).
          gsub('//', "/#{action}/").
          gsub('/"', "/#{path}\"").
          gsub('><', ">#{text}<")
      end

      # p
      def text(text)
        (@text ||= Base64.
          decode64("PHA+PC9wPg==\n")).
          gsub '><', ">#{text}<"
      end

      # pre
      def formated(text)
        (@formated ||= Base64.
          decode64("PHByZT48L3ByZT4=\n")).
          gsub '><', ">#{text}<"
      end

      # the most ludicrously rendered
      # HTML line-break in the world, na ?
      def new_line
        @new_line ||= Base64.
          decode64("PGJyLz4=\n")
      end

      # try to display file contents in HTML page
      def content(path)
        # img tag
        if path.mime.start_with?('image')
          image path
        # pre section with file contents
        elsif path.mime.start_with?('text')
          formated path.read
        # link to download
        else
          link 'media', path, "Download #{path.basename} here"
        end
      end

      # Mmmh... What ?
      def parent_link(path)
        link 'browse', path.dirname, 'Parent directory'
      end

      # link depending on what's to be linked
      def cell_link(cell)
        send cell.linker, cell
      end

      # Mmmh... Er ?
      def show_link(path)
        link 'show', path, path.basename
      end

      # Mmmh... Er what ?
      def browse_link(path)
        link 'browse', path, path.basename
      end

    end

  end

end
