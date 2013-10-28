# Apidae

Apidae is a Sinatra template-engine-agnostic code base to easily write webapp'
that will browse filesystems. As is, `apidae` already provides a small set of
browsing features, but the user experience is at best minimalist.

The idea is more to subclass `apidae` libs, overload on or two methods, choose a
template engine, and roll.

## Installation

Ruby 1.9.2 is required.

Install it with rubygems:

    gem install apidae

With bundler, add it to your `Gemfile`:

```ruby
gem "apidae"
```

## Use

### Out of the box

```
apidae --help # to get the executable options

# to start a server on port 4567, browsing file starting from current directory
apidae

# to start a server on port 9000, browsing files starting from /that/directory
# with your web browser
apidae --port 9000 --browse /that/directory

```

### `apidae` libs

Mainly, there are two classes : Apidae::Swarm, the server code base inheriting
from Sinatra::Base, and relying on `ways-and-means` gem for a few things like
the application routing.

See [ways-and-means](https://github.com/lacravate/ways-and-means)


The Apidae::Cell, inheriting from Pathstring (for all its file/path related
abilities), modeling the filesystem elements.

See [pathstring](https://github.com/lacravate/pathstring)

```

module YourModule

  class YourClass < Apidae::Swarm

    # setup some routes routes
    # with the help of ways-and-means gem
    ways_and_means! ways: [ 'myjob/*' ]

    # or the vanilla way
    get "/some_stuff_to_do" do
      # do the right stuff
    end

    # Give the Swarm infos it need to operate
    set :root_class, PathstringRoot # the class modeling the document root
    set :branching_class, Apidae::Cell # the class modeling the filesystem
                                       # items, instantiated by the above

    # ways-and-means automatically setup a route with a callback leading here
    def myjob
      # here you can do stuff with
      #   `current` is the current filesystem item accessed
      #   `branching` are its children if it's a directory
      #   `wire_branching` are its directory children if it's a directory
      #   `leaf_branching` are its file children if it's a directory
      #
      #   `location` is the document root
    end

  end

end

```

## Thanks

Eager and sincere thanks to all the Ruby guys and chicks for making all this so
easy to devise.

## Copyright

I was tempted by the WTFPL, but i have to take time to read it.
So far see LICENSE.
