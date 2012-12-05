# encoding: utf-8

# Libraries API best bud !
require 'forwardable'

# MIME types... unsatisfactory though
require 'rack/mime'

# the modules below are all included by the application
# the class is how we want to model paths
module Apidae

  # Contruct handles the output elements pile
  # Basically an Array that knows how to pre-fill
  # itself (with layout), and which of its elements
  # can be refered to as body and title

  # This may be short-lived. 'Don't like it...
  module Construct

    def construct
      # Layout we add the elements to
      (@construct ||= Wax::Assemblage.new).tap do |a|
        # if title is not already set
        if a.title == a.title_stub
          a.title << current_path
          current_path.file? || a.title << '/'
        end
        yield a.body if block_given?
      end
    end

    # convenient current_path method
    # relies on the very simple routing
    # not sure i like that one either
    def current_path
      # nasty parentheses-operator-bloated line
      # but i hate doing more for that kind of stuff
      # So : 
      #  - current path as a Cell instance
      #  - string is splat if any
      #  -  '' otherwise
      @current_path ||= honeycomb((params.any? && params['splat'].first) || '')
    end

  end

  # The queen names what the hive cells are made of and 
  # the cell map in the hive

  # Not sure of the module name and its responsibilities
  # Likely to change as well...
  module Queen

    # Hive construct is made of...
    def honeycomb(cell)
      Cell.new cell
    end

    # what's where
    def cells_at(path=nil)
      Dir[Apidae::Hive.location.join (path || current_path), '*'].sort.each do |cell|
        yield honeycomb(cell)
      end
    end

    # Well... because i like apt method names
    alias :cells :cells_at

  end

  # the worker does the job
  # the routes handlers are here
  module Worker

    # directories, lists, whatever
    def row
      construct do |assemblage|
        # parent_link if not displaying the 
        # designated root directory
        current_path.empty? || assemblage <<
          Wax.parent_link(current_path) <<
          Wax.new_line << Wax.new_line

        # this is where you are buddy, and what's listed below
        assemblage << Wax.text("Contents of #{current_path}/ :")

        # for each cell in the row
        cells do |cell|
          assemblage <<
            # add a link to its show page
            Wax.cell_link(cell) <<
            Wax.new_line
        end
      end
    end

    # cell, file, individuals, whatever
    def cell
      # (oh... that's why current_path
      # responds to Pathname interface !)
      construct <<
        # what's your name ?
        Wax.text(current_path.basename) <<
        # who's your daddy ?
        Wax.parent_link(current_path) <<
        Wax.new_line << Wax.new_line <<
        # there you are !
        Wax.content(current_path)
    end

    # serve cell, file, individual, whatever, contents
    def honey
      # (oh... that's why current_path
      # responds to Pathname interface !)
      # current_path file contents slurp
      current_path.read unless current_path.absolute_name.empty?
    end

  end

  # this is the interface of a cell, file, individual, whatever,
  # in the file tree.

  # I made it a string responding to some of the Pathname
  # interface, but it'll probably change into a Pathname
  # who knows when to stringify itself when needed
  class Cell < String

    # Libraries API best bud ! Right ?
    extend Forwardable

    # Mime, well you know why, linker you don't.
    # Bad news, me neither, or not really
    attr_reader :mime, :linker

    # will use two different pathnames to define its
    # interface
    def_delegators :@absolute, :file?, :basename, :extname, :read
    def_delegators :@pathname, :dirname
    def_delegator :@absolute, :to_s, :absolute_name

    def initialize(path)
      # i want an absolute pathname to make sure i know where and what
      # we are accessing to
      @absolute = Pathname path.start_with?('/') ? path : Apidae::Hive.location.join(path)

      # a second one because i want the cell to know, all the time,
      # without post-processing how it is located against the application
      # root. 'Could have contrived this otherwise but that's my choice
      # for now
      @pathname = @absolute.relative_path_from Apidae::Hive.location

      @mime = Rack::Mime.mime_type extname

      # oh... That's what the linker is... Ok, i know now, but i still
      # don't know... why.
      @linker = file? ? 'show_link' : 'browse_link'

      # initialize string
      # current directory '.' is sent back to its actual emptiness
      super @pathname.to_s == '.' ? '' : @pathname.to_s
    end

  end

end
