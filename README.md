# Apidae

Apidae is (well... intends to be) a Sinatra template-engine-agnostic code base
to easily write web applications that will browse filesystems. As is, `apidae`
already provides a small set of browsing features, but the user experience is
at best minimalist.

The idea is more to subclass `apidae` libs, overload two methods, choose a
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

### `apidae` executable

```
apidae --help # to get the executable options

# to start a server on port 4567, browsing file starting from current directory
apidae

# to start a server on port 9000, browsing file starting from /that/directory
apidae --port 9000 --browse /that/directory
```

### `apidae` libs

#### Hive

`Apidae::Hive` is the Sinatra app'.

It defines four GET routes :
 - browse    # application root
 - browse/*  # list files in *
 - show/*    # show file *
 - read/*    # dumps file * contents

Throughout the scope of the `Hive`, are available :
 - `location`  is the document root
 - `current`   is the path requested through the user GET request
 - `branching` is the files list under `current` if `current` is a directory

#### Classes

Unless you decide and set it otherwise :
  - `current` is cast by `location` as an `Apidae::Cell`
    `Apidae::Cell` is a fitting class derived from
    [PathstringRoot](https://github.com/lacravate/pathstring#use).
    It is a representation of the filesystem element, with a mainstream
    `Pathname`-like interface. It has for instance the method `dirname` that
    would let you easily craft a link to parent directory

  - `location` is a `PathstringRoot`
    [PathstringRoot](https://github.com/lacravate/pathstring#pathstringroot)
    is a class utility that instantiates (in the case of `apidae`)
    `Apidae::Cell` objects with itself as document root. Among other things, it
    provides `branching` method to the `Hive`, giving the files list of the
    current requested directory (as `Apidae::Cell` or anything you specified)

If you want to change that, i strongly recommend (at least for now) that the
replacements are derived from the above-mentionned classes. And you will have to
tell the `Hive`, or its descendant, about it.

To have your own version of the application running, here's what you could do :

```ruby
require 'apidae'



```

## Thanks

Eager and sincere thanks to all the Ruby guys and chicks for making all this so
easy to devise.

## Copyright

I was tempted by the WTFPL, but i have to take time to read it.
So far see LICENSE.
