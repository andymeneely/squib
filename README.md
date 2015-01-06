# Squib [![Gem Version](https://badge.fury.io/rb/squib.svg)](https://rubygems.org/gems/squib) [![Build Status](https://secure.travis-ci.org/andymeneely/squib.svg?branch=master)](https://travis-ci.org/andymeneely/squib) [![Dependency Status](https://gemnasium.com/andymeneely/squib.svg)](https://gemnasium.com/andymeneely/squib) [![Coverage Status](https://img.shields.io/coveralls/andymeneely/squib.svg)](https://coveralls.io/r/andymeneely/squib) [![Inline docs](http://inch-ci.org/github/andymeneely/squib.png?branch=master)](http://inch-ci.org/github/andymeneely/squib)
Squib is a Ruby [DSL](http://en.wikipedia.org/wiki/Domain-specific_language) for prototyping card and board games. Write a little bit of Ruby, define your deck's stats, and you can compile your game into a series of images ready for print-and-play or even print-on-demand. Squib is very data-driven and built on the principle of Don't Repeat Yourself. Think of it like [nanDeck](http://www.nand.it/nandeck/) done "the Ruby way". Squib supports:

* A concise set of rules for laying out your cards
* Loading PNGs and SVGs using [Cairo](http://cairographics.org/)
* Complex text rendering using [Pango](http://www.pango.org/)
* Reading `xlsx` and `csv` files
* Rendering to individual PNGs or PDF sheets
* Flexible, data-driven layouts in Yaml
* Basic shape drawing
* Unit conversion
* The full power of Ruby!

Check this out.

```ruby
require 'squib'

Squib::Deck.new(cards: 2) do
  text str: %w(Hello World!)
  save_png
end
```

We just created a 2-card deck with "Hello" on the first card, and "World" on the second, and saved them out to PNGs.

## Installation

Install it yourself with:

    $ gem install squib

If you're using Bundler, add this line to your application's Gemfile:

    gem 'squib'

And then execute:

    $ bundle

Note: Squib has some native dependencies, such as [Cairo](https://github.com/rcairo/rcairo), [Pango](http://ruby-gnome2.sourceforge.jp/hiki.cgi?Pango%3A%3ALayout), and [Nokogiri](http://nokogiri.org/), which may require compiling C code to install. This is usually not painful at all, but can cause headaches on some setups. For Windows users, I *strongly* recommend using the *non-64 bit* RubyInstaller at http://rubyinstaller.org along with installing DevKit. For Mac, I recommend using [rvm](https://rvm.io).

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
_output/gitkeep.txt
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

About the other files:
  * `Gemfile` is for adding in other gems if you are using `bundler`
  * `config.yml` is a skeleton config file with various options commented out. See {file:README.md#Configuration_File Configuration File}.
  * `layout.yml` is a skeleton layout file if you want to use it. See {file:README.md#Custom_Layouts Custom Layouts}.
  * `_output` is the directory where your built files will go. Can easily be changed, of course.
  * `.gitignore` and `gitkeep.txt` are for if you are using Git. See {file:README.md#Source_control Source control}. (Feel free to remove these if you are not using Git.)
  * `ABOUT.md` and `PHP NOTES.md` are Markdown files for posting. Not used by Squib, but there by convention.
  * `Rakefile` is a basic build file. Not required but handy - see {file:README.md#Rakefile Rakefile}

# Learning Squib

After going over this README, here are some other places to go learn Squib:

* The YARD-generated API documentation [for the latest Squib gem](http://rubydoc.info/gems/squib/) is a method-by-method reference. The `Deck` class is the main class to look at. If you are following Squib master, see [the latest version](http://rubydoc.info/github/andymeneely/squib)
* The `samples` directory in the [source repository](https://github.com/andymeneely/squib) has lots of examples.
* [Junk Land](https://github.com/andymeneely/junk-land) is my own creation that's uses Squib for both black-and-white print-and-play and full color.

## Viewing this README

The best place to read this documentation is on [our website](http://andymeneely.github.io/squib/doc).

If you want to view it offline, you can do the following

```sh
$ gem install yard
$ yard server --gems
```
Then go to [http://localhost:8808/docs/squib/file/README.md](http://localhost:8808/docs/squib/file/README.md)

If you're viewing this on Github, you might see some confusing tags like `{include:file:...}` - these are directives for YARD to show the embedded examples. Github doesn't render those and you might find them helpful.

Also, RubyDoc.info linked from RubyGems is buggy and doesn't support `{include:file...}` directive properly, so the embedded samples will also not show up there.

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

## Arrays and Singleton Expansion

Many inputs to Squib can accept `Arrays`, which correspond to the entire deck. In fact, under the hood, if Squib is _not_ given an array, it expands it out to an array before rendering. This allows for different styles to apply to different cards. This example comes from the [ranges.rb example](https://github.com/andymeneely/squib/tree/master/samples/ranges.rb)

```ruby
# This renders three cards, with three strings that had three different colors at three different locations.
text str: %w(red green blue),
     color: [:red, :green, :blue],
     x: [40, 80, 120],
     y: [700, 750, 800]
```

Under the hood, Squib actually views every argument as applied each card individually. If a single argument is given to the command, it's considered a singleton that gets expanded into a deck-sized array. Supplying the array bypasses that array. This means that any array you supply instead of a singleton ought to be the same size as the deck and align the same way the indexes in the supplied `range` are.

## Specifying Ranges

Most public `Deck` methods allow a `range` to be specified as a first parameter. This parameter is used to access an internal `Array` of `Squib::Cards`. This can be an actual Ruby range, or anything that implements `#each` (thus can be an `Enumerable`). Integers are also supported for changing one card only. Negatives work from the back of the deck. Here are some examples from `samples/ranges.rb` found [here](https://github.com/andymeneely/squib/tree/master/samples/ranges.rb)

{include:file:samples/ranges.rb}

## Units

By default, Squib thinks in pixels. This decision was made so that we can have pixel-perfect layouts without automatically scaling everything, even though working in units is sometimes easier. We provide some conversion methods, including looking for strings that end in "in" and "cm" and computing based on the current DPI. Example is in `samples/units.rb` found [here](https://github.com/andymeneely/squib/tree/master/samples/units.rb)

{include:file:samples/units.rb}

Note: we do not support unit conversion on `save_pdf` and `Squib::Deck.new()`, [yet](https://github.com/andymeneely/squib/issues/21)

## Specifying Colors

Colors can be specified in a wide variety of ways, mostly in a hex-string. Take a look at the examples from `samples/colors.rb`, found [here](https://github.com/andymeneely/squib/tree/master/samples/colors.rb)

{include:file:samples/colors.rb}

Under the hood, Squib uses the `rcairo` [color parser](https://github.com/rcairo/rcairo/blob/master/lib/cairo/color.rb) to accept a variety of color specifications, along with over [300 pre-defined constants](https://github.com/rcairo/rcairo/blob/master/lib/cairo/colors.rb).

## Specifying Files

All files opened for reading or writing (e.g. for `png` and `xlsx`) are opened relative to the current directory. Files opened for writing (e.g. for `save_png`) will be overwritten without warning.

## Custom Layouts

Working with x-y coordinates all the time can be tiresome, and ideally everything in a game prototype should be data-driven and easily changed. For this, many Squib methods allow for a `layout` to be set. In essence, layouts are a way of setting default values for any argument given to the command.

To use a layout, set the `layout:` option on a `Deck.new` command to point to a YAML file. Any command that allows a `layout` option can be set with a Ruby symbol or String, and the command will then load the specified `x`, `y`, `width`, and `height`. The individual command can also override these options.

Note: YAML is very finnicky about having not allowing tabs. Use two spaces for indentation instead. If you get a `Psych` syntax error, this is likely the culprit. Indendation is also strongly enforced in Yaml too. See the [Yaml docs](http://www.yaml.org/YAML_for_ruby.html).

Layouts will override Squib's defaults, but are overriden by anything specified in the command itself. Thus, the order of precedence looks like this:

* Use what the command specified
* If anything was not yet specified, use what was given in a layout (if a layout was specified in the command and the file was given to the Deck)
* If still anything was not yet specified, use what was given in Squib's defaults.

Layouts also allow merging, extending, and combining layouts. The sample demonstrates this, but they are also explained below. See the `layouts.rb` sample found [here](https://github.com/andymeneely/squib/tree/master/samples/)

{include:file:samples/layouts.rb}

### Merge Keys and `extends`

Since Layouts are in Yaml, we have the full power of that data format. One particular feature you should look into are ["merge keys"](http://www.yaml.org/YAML_for_ruby.html#merge_key). With merge keys, you can define base styles in one entry, then include those keys elsewhere. For example:

```yaml
icon: &icon
  width: 50
  height: 50
icon_left
  <<: *icon
  x: 100
# The layout for icon_left will have the width/height from icon!
```

Also!! Squib provides a more feature-rich way of merging: the `extends` key in layouts. When defining an extends key, we can merge in another key and modify data coming in if we want to. This allows us to do things like set an inner object that changes its location based on its parent.

```yaml
yin:
  x: 100
  y: 100
  radius: 100
yang:
  extends: yin
  x: += 50
```

Furthermore, if you want to extend multiple parents, it looks like this:

```yaml
socrates:
  x: 100
aristotle:
  y: 200
aristotle:
  extends:
    - socrates
    - plato
  x: += 50
```

### Multiple layout files

Squib also supports the combination of multiple layout files. As shown in the above example, if you provide an `Array` of files then Squib will merge them sequentially. Colliding keys will be completely re-defined by the later file. Extends is processed after _each file_. YAML merge keys are NOT supported across multiple files - use extends instead. Here's a demonstrative example:

```yaml
# load order: a.yml, b.yml

##############
# file a.yml #
##############
grandparent:
  x: 100
parent_a:
  extends: grandparent
  x: += 10   # evaluates to 110
parent_b:
  extends: grandparent
  x: += 20   # evaluates to 120

##############
# file b.yml #
##############
child_a:
  extends: parent_a
  x: += 3    # evaluates to 113
parent_b:    # redefined
  extends: grandparent
  x: += 30   # evaluates to 130
child_b:
  extends: parent_b
  x: += 3    # evaluates to 133
```

This can hopefully be helpful for:
  * Creating a base layout for structure, and one for color (for easier color/black-and-white switching)
  * Sharing base layouts with other designers

### Built-in Layout Files

If your layout file is not found in the current directory, Squib will search for its own set of layout files (here's the latest the development version [on GitHub](https://github.com/andymeneely/squib/tree/master/lib/squib/layouts). See the `layouts.rb` sample found [here](https://github.com/andymeneely/squib/tree/master/samples/) for some demonstrative examples.

## Configuration File

Squib supports various configuration properties that can be specified in an external file. The `config:` option in `Deck.new` can specify an optional configuration file in YML format. The properties there are intended to be immutable for the life of the Deck. The options include:

* `progress_bars` (Boolean, default: false).  When set to `true`, long-running operations will show a progress bar on the command line.
* `dpi` (Integer, default: 300). Used in calculations when units are used (e.g. for PDF rendering and unit conversion).
* `hint` (ColorString, default: off). Text hints are used to show the boundaries of text boxes. Can be enabled/disabled for individual commands, or set globally with the `set` command. This setting is overriden by `set` and individual commands.
* `custom_colors` (Hash of Colors, default: {}). Defines globally-available colors available to the deck that can be specified in commands.

The following sample demonstrates the config file.

See the `custom_config` sample found [here](https://github.com/andymeneely/squib/tree/master/samples/)

{include:file:samples/custom_config.rb}

## Importing from Excel and CSV

Squib supports importing data from `xlsx` files and `csv` files. These methods are column-based, which means that they assume you have a header row in your table, and that header row will define the column. Squib will return a `Hash` of `Arrays` correspoding to each row. Warnings are thrown on things like duplicate columns. See the `excel.rb` and the `csv_import.rb` sample found [here](https://github.com/andymeneely/squib/tree/master/samples/).

{include:file:samples/excel.rb}

Of course, you can always import your game data other ways using just Ruby. There's nothing special about Squib's methods other than their convenience.

## Making Squib Verbose

By default, Squib's logger is set to WARN, but more fine-grained logging is embedded in the code. To set the logger, just put this at the top of your script:

```ruby
Squib::logger.level = Logger::INFO
```

If you REALLY want to see tons of output, you can also set DEBUG, but that's not intended for general consumption.

## Staying DRY

Squib tries to keep you DRY (Don't Repeat Yourself) with the following features:

* Custom layouts allow you to specify various arguments in a separate file. This is great for x-y coordinates and alignment properties that would otherwise clutter up perfectly readable code. Yaml's "merge keys" takes this a step further and lets you specify base styles that can then be extended by other styles. Squib goes even further and has a special "extends" that works especially well for grouped-together styles.
* Flexible ranges and array handling: the `range` parameter in Squib is very flexible, meaning that one `text` command can specify different text in different fonts, styles, colors, etc. for each card. If you find yourself doing multiple `text` command for the same field across different ranges of cards, there's probably a better way to condense.
* Custom colors keep you from hardcoding magic color strings everywhere. Custom colors go into `config.yml` file.
* Plus, you know, Ruby.

## Source control

You are using source control, right??

By default, Squib assumes Git. But it's not dogmatic about it. Tracking your progress, backing up, sharing data, topic branches, release management, and reverting into history are just some of the many, many useful things you can do with source control. For me, I tend to ignore any auto-generated files in my output folder, but version control everything else. I also try to keep my graphics vector files, so the files stay small. Version control is intended for source code, so large binary files that change often probably should not get checked in unless absolutely necessary. I tend to keep big raster graphics files (e.g. from Gimp) in cloud storage or elsewhere.

## SublimeText

Using SublimeText? I like you already. I've written up some Squib snippets to ease remembering Squib commands. It's called `Squib Snippets` on Package Control. Compatible with SublimeText 3. Source code is also [on Github](https://github.com/andymeneely/sublime-squib) (contributions welcome!). Check it out:

![Sublime Squib Snippets](https://raw.githubusercontent.com/andymeneely/squib/screencasts/sublime-squib-snippets.gif)

## Decks with multiple orientations or sizes

If you want to make a deck that has some portrait and some landscape cards, I recommend you use multiple `Squib::Deck`s. The pixel size of a given card is designed to not change thorughout the life of a `Squib::Deck`. To work with landscape cards, there is a `rotate` option on `save_png` so you can render your print-on-demand PNGs in portrait but keep everything else oriented toward landscape. The following example demonstrates how to do this, found [here](https://github.com/andymeneely/squib/tree/master/samples/portrait-landscape.rb).

{include:file:samples/portrait-landscape.rb}

## Rakefile

New Squib projects come with a basic Rakefile. At this stage, it's basically just a shortcut for `ruby deck.rb` or whatever. But, even so this Rakefile has some advantages:

* If you're in a subdirectory at the time, `rake` will simply traverse up an `cd` to the proper directory so you don't get rogue `_output` directories
* If you find yourself building multiple decks, you can make your own tasks for each one individually, or all (e.g. `rake marketing`)
* Don't need the `require squib` at the top of your code (although that breaks `ruby deck.rb`, so it's probably a bad idea)

Here's what's included in a `squib new` command:

{include:file:lib/squib/project_template/Rakefile}

# Development

Squib is currently in pre-release alpha, so the API is still maturing. I do change my mind about the names and meaning of things at this stage. If you are using Squib, however, I'd love to hear about it! Feel free to [file a bug or feature request](https://github.com/andymeneely/squib/issues).

# Contributing

Squib is an open source tool, and I would love participation. If you want your code integrated:

1. Fork it ( https://github.com/[my-github-username]/squib/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

# What's up the with the name?

Truthfully, I just thought it was a cool, simple word that was not used much in the Ruby community nor the board game community. But, now that I've committed to the name, I've realized that:

* Squibs are small explosive devices, much like Squib "explodes" your rules into a playable game
* Squibs are often used in heist movies, leading to a sudden plot twist that often resembles the twists of good tabletop game
* Squibs are also part of the Harry Potter world - they are people who are non-magical but wizard-born. Squib is aware of wizarding magic and comes from that heritage, but it's not magical itself.