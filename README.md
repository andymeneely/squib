# Squib [![Gem Version](https://badge.fury.io/rb/squib.svg)](https://rubygems.org/gems/squib) [![Build Status](https://secure.travis-ci.org/andymeneely/squib.svg?branch=master)](https://travis-ci.org/andymeneely/squib) [![Dependency Status](https://gemnasium.com/andymeneely/squib.svg)](https://gemnasium.com/andymeneely/squib) [![Coverage Status](https://img.shields.io/coveralls/andymeneely/squib.svg)](https://coveralls.io/r/andymeneely/squib) [![Inline docs](http://inch-ci.org/github/andymeneely/squib.png?branch=master)](http://inch-ci.org/github/andymeneely/squib)
Squib is a Ruby [DSL](http://en.wikipedia.org/wiki/Domain-specific_language) for prototyping card and board games. With Squib, you just write a little bit of Ruby and you can compile your game's data and images into a series of images raedy for print-and-play or even print-on-demand. Squib is very data-driven - think of it like [nanDeck](http://www.nand.it/nandeck/) done "the Ruby way". Squib supports:

* A concise set of rules for laying out your cards
* Loading PNGs and SVGs using [Cairo](http://cairographics.org/)
* Complex text rendering using [Pango](http://www.pango.org/)
* Reading `.xlsx` files
* Basic shape drawing
* Rendering decks to PNGs and PDFs
* Data-driven layouts
* Unit conversion
* Plus the full power of Ruby! 

Check this out. 

```ruby
require 'squib'

Squib::Deck.new do
  text str: 'Hello, World!'  
  save_png
end
```

That script just created a deck of with 1 image at 825x1125 with the string "Hello, World" in the upper-left corner.

## Installation

Install it yourself with:

    $ gem install squib

If you're using Bundler, add this line to your application's Gemfile:

    gem 'squib'

And then execute:

    $ bundle

Note: Squib has some native dependencies, such as [Cairo](https://github.com/rcairo/rcairo), [Pango](http://ruby-gnome2.sourceforge.jp/hiki.cgi?Pango%3A%3ALayout), and [Nokogiri](http://nokogiri.org/), which all require DevKit to compile C code. This is usually not painful, but can cause headaches on some setups. For Windows users, I *strongly* recommend using the *non-64 bit* RubyInstaller at http://rubyinstaller.org. For Mac, I recommend using [rvm](https://rvm.io). 

Note: Squib requires Ruby 2.0 or later.

## Getting Started

After installing Squib, you can create a project and run your first build like this:

```sh
$ squib new my-cool-game
$ cd my-cool-game
$ ruby deck.rb
```

The `squib new` command will generate files and folders like this:

```
_output
  gitkeep.txt
.gitignore
ABOUT.md
config.yml
deck.rb
Gemfile
layout.yml
PNP NOTES.md
```

The central file here is `deck.rb`. Here's a [basic example](https://github.com/andymeneely/squib/tree/master/samples/basic.rb) of a deck to work from:

{include:file:samples/basic.rb basic.rb}

# Learning Squib

After going over this README, here are some other places to go learn Squib:

* The YARD-generated API documentation [for the latest Squib gem](http://rubydoc.info/gems/squib/) is a method-by-method reference. The `Deck` class is the main class to look at. If you are following Squib master, see [the latest version](http://rubydoc.info/github/andymeneely/squib)
* The `samples` directory in the [source repository](https://github.com/andymeneely/squib) has lots of examples. To run them, you will need to clone the repository and run them with Squib installed. 
* Junk Land (link TBD) is my own creation that's uses Squib for both black-and-white print-and-play and full color.

## Viewing this README

If you're viewing this on Github, you might see some confusing tags like `{include:file:...}` - these are directives for Yard to show the embedded examples. These can be found on RubyDoc.info:

 * The [latest Gem release](http://rubydoc.info/gems/squib/)
 * The [master branch](http://rubydoc.info/github/andymeneely/squib) of this repository 

## Squib API

The Squib DSL is based on a collection of methods provided to the `Squib::Deck` class. The general philosophy of Squib is to specify as little as possible with layers of defaults, highly flexible input, and good ol' Ruby duck-typing. Ruby does a lot to make Squib useful.

Squib essentially has two main classes: `Deck` and `Card`. `Deck` is the front-end, and `Card` is the back-end. The contract of `Deck` is to do the various manipulations of options and then delegate the operation to `Card` to do the low-level graphical operations. 

For most users, I recommending solely using `Deck` methods. If you want to roll up your sleeves and get your hands messy, you can access the Cairo or Pango contexts the directly via the `Card` class. The API documentation doesn't really cover these, however, so you're on your own there.

## Specifying Parameters

Squib is all about sane defaults and shorthand specification. Arguments are almost always using hashes, which look a lot like [Ruby 2.0's named parameters](http://www.ruby-doc.org/core-2.0.0/doc/syntax/calling_methods_rdoc.html#label-Keyword+Arguments). This means you can specify your parameters in any order you please. All parameters are optional. For example `x` and `y` default to 0 (i.e. the upper-left corner of the card). Any parameter that is specified in the command overrides any Squib defaults, `config.yml` settings, or layout rules. 

Note: you MUST use named parameters rather than positional parameters. For example: `save :png` will lead to an error like this:

    C:/Ruby200/lib/ruby/gems/2.0.0/gems/squib-0.0.3/lib/squib/api/save.rb:12:in `save': wrong number of arguments (2 for 0..1) (ArgumentError)
        from deck.rb:22:in `block in <main>'
        from C:/Ruby200/lib/ruby/gems/2.0.0/gems/squib-0.0.3/lib/squib/deck.rb:60:in `instance_eval'
        from C:/Ruby200/lib/ruby/gems/2.0.0/gems/squib-0.0.3/lib/squib/deck.rb:60:in `initialize'
        from deck.rb:18:in `new'
        from deck.rb:18:in `<main>'

Instead, you must name the parameters: `save format: :png`

Furthermore, many inputs to Squib can accept `Arrays`, which correspond to the entire deck. In fact, under the hood, if Squib is _not_ given an array, it expands it out to an array before rendering. This allows for different styles to apply to different cards. This example comes from the [ranges.rb example](https://github.com/andymeneely/squib/tree/master/samples/ranges.rb)

```ruby
# This renders three cards, with three strings that had three different colors at three different locations.
text str: %w(red green blue),
     color: [:red, :green, :blue],
     x: [40, 80, 120],
     y: [700, 750, 800]
```

## Specifying Ranges

Most public `Deck` methods allow a `range` to be specified as a first parameter. This parameter is used to access an internal `Array` of `Squib::Cards`. This can be an actual Ruby range, or anything that implements `#each` (thus can be an `Enumerable`). Integers are also supported for changing one card only. Negatives work from the back of the deck. Here are some examples from `samples/ranges.rb` found [here](https://github.com/andymeneely/squib/tree/master/samples/ranges.rb)

{include:file:samples/ranges.rb}

## Pixels and Other Units

By default, Squib thinks in pixels. This decision was made so that we can have pixel-perfect layouts without automatically scaling everything, even though working in units is sometimes easier. To convert, we provide the `Deck#inch` method, as shown in `samples/units.rb` found [here](https://github.com/andymeneely/squib/tree/master/samples/units.rb)

{include:file:samples/units.rb}

## Specifying Colors

Colors can be specified in a wide variety of ways, mostly in a hex-string. Take a look at the examples from `samples/colors.rb`, found [here](https://github.com/andymeneely/squib/tree/master/samples/colors.rb)

{include:file:samples/colors.rb}

Under the hood, Squib uses the `rcairo` [color parser](https://github.com/rcairo/rcairo/blob/master/lib/cairo/color.rb) to accept a variety of color specifications, along with over [300 pre-defined constants](https://github.com/rcairo/rcairo/blob/master/lib/cairo/colors.rb). 

## Specifying Files

All files opened for reading or writing (e.g. for `png` and `xlsx`) are opened relative to the current directory. Files opened for writing (e.g. for `save_png`) will be overwritten without warning. 

## Custom Layouts

Working with x-y coordinates all the time can be tiresome, and ideally everything in a game prototype should be data-driven and easily changed. For this, many Squib methods allow for a `layout` to be set. In essence, layouts are a way of setting default values for any argument given to the command. 

To use a layout, set the `layout:` option on a `Deck.new` command to point to a YAML file. Any command that allows a `layout` option can be set with a Ruby symbol or String, and the command will then load the specified `x`, `y`, `width`, and `height`. The individual command can also override these options. 

Note: YAML is very finnicky about having tabs in the file. Use two spaces for indentation instead.

Layouts will override Squib's defaults, but are overriden by anything specified in the command itself. Thus, the order of precedence looks like this:

* Use what the command specified
* If anything was not yet specified, use what was given in a layout (if a layout was specified in the command and the file was given to the Deck)
* If still anything was not yet specified, use what was given in Squib's defaults.

Layouts also allow for a special `extends` field that will copy all of the settings from another entry. Only a single level of extends are supported currently (contact the developer if you want multiple levels). 

See the `use_layout` sample found [here](https://github.com/andymeneely/squib/tree/master/samples/)

{include:file:samples/use_layout.rb}

## Configuration File

Squib supports various configuration properties that can be specified in an external file. The `config:` option in `Deck.new` can specify an optional configuration file in YML format. The properties there are intended to be immutable for the life of the Deck. The options include:

* `progress_bars` (Boolean, default: false).  When set to `true`, long-running operations will show a progress bar on the command line. 
* `dpi` (Integer, default: 300). Used in calculations when units are used (e.g. for PDF rendering and unit conversion).
* `hint` (ColorString, default: nil). Text hints are used to show the boundaries of text boxes. Can be enabled/disabled for individual commands, or set globally with the `set` command. This setting is overriden by `set` and individual commands.
* `custom_colors` (Hash of Colors, default: {}). Defines globally-available colors available to the deck that can be specified in commands.

The following sample demonstrates the config file.

See the `custom_config` sample found [here](https://github.com/andymeneely/squib/tree/master/samples/)

{include:file:samples/custom_config.rb}

# Squib Principles and Patterns

I am eating my own dogfood and using Squib for prototyping my own games. From that experience, here are some pieces of advice. They are really just re-hashing of common Ruby community and good software engineering practices.

## Stay DRY (Don't Repeat Yourself)

This is Good Advice for all software development, but in the Ruby world and with Squib, it's especially true. Do your best not to repeat yourself, making your code as concise as is readably possible.  Aside from being ugly, copied or near-copied code is much harder to maintain because you're essentially duplicating your bugs every time you copy. If you find yourself copying and making small adaptations, there's probably a much more condensed and elegant way to do it. 

Squib tries to keep you dry with the following features:

* Custom layouts allow you to specify your data in a separate file. The `extends` takes this a step further and lets you specify base styles that can then be extended by other styles.
* Flexible ranges and array handling: the `range` parameter in Squib is very flexible, meaning that one `text` command can specify different text in different fonts, styles, colors, etc. for each card. If you find yourself doing multiple `text` command for the same field across different ranges of cards, there's probably a better way to condense.

## Prefer data-driven over `if`

If-statements are great, except when they aren't. Squib works by executing commands on subsets of the deck, which means that those subsets can be data-driven. Make use of Ruby's rich methods on Array, such as `select`, `inject`, and other set theory commands.

This rule is also similar to "Convention over Configuration" principle that is prevalent in Ruby. Set up those hashes and arrays with logical names, and use those logical names to connect everything together. For example, if you have an "attack" icon you want to place, then in your SVG file give it an id of "attack" and your Excel file with "attack". Keeping the naming consistent makes things readable and connects them together without if-statements or glue code.

## Don't hardcode magic numbers

You might be tempted to hardcode card numbers into your `range` fields. While this might work momentarily to get things working, I highly recommend setting up an `id` hash that maps a card's name to it's number. This makes your code both more readable and future-proof for when you add or remove cards. An example can be found [here](https://github.com/andymeneely/squib/tree/master/samples/ranges.rb).

## Use source control

You are using source control, right??

By default, Squib assumes Git. But it's not dogmatic about it. Tracking your progress, backing up, sharing data, topic branches, release management, and reverting into history are just some of the many, many useful things you can do with source control.

For me, I tend to ignore any auto-generated files in my output folder, but version control everything else. I also try to keep my graphics vector files, so the files stay small. Version control is intended for source code, so large binary files don't usually get checked in unless absolutely necessary.

# Development

Squib is currently in pre-release alpha, so the API is still maturing. If you are using Squib, however, I'd love to hear about it! Feel free to [file a bug or feature request](https://github.com/andymeneely/squib/issues).

# Contributing

Squib is an open source tool, and I would love participation. If you want your code integrated:

1. Fork it ( https://github.com/[my-github-username]/squib/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
