# Squib [![Gem Version](https://badge.fury.io/rb/squib.svg)](https://rubygems.org/gems/squib) [![Build Status](https://secure.travis-ci.org/andymeneely/squib.svg?branch=master)](https://travis-ci.org/andymeneely/squib) [![Dependency Status](https://gemnasium.com/andymeneely/squib.svg)](https://gemnasium.com/andymeneely/squib) [![Coverage Status](https://img.shields.io/coveralls/andymeneely/squib.svg)](https://coveralls.io/r/andymeneely/squib) [![Inline docs](http://inch-ci.org/github/andymeneely/squib.png?branch=master)](http://inch-ci.org/github/andymeneely/squib)
Squib is a Ruby [DSL](http://en.wikipedia.org/wiki/Domain-specific_language) for prototyping card and board games. Write a little bit of Ruby, define your deck's stats, then compile your game into a series of images ready for print-and-play or even print-on-demand. Squib is very data-driven and built on the principle of Don't Repeat Yourself. Think of it like [nanDeck](http://www.nand.it/nandeck/) done "the Ruby way". Squib supports:

* A concise set of rules for laying out your cards
* Loading PNGs and SVGs
* Complex text rendering using [Pango](http://www.pango.org/)
* Reading `xlsx` and `csv` files
* Rendering to PNGs, PDFs, and SVGs (sheets or individual files)
* Flexible, data-driven layouts in Yaml
* Basic shape drawing, blending operators, gradients, etc.
* Unit conversion
* The full power of Ruby!

Squib is based on the [Cairo](http://cairographics.org/) graphics rendering engine, the library of choice for WebKit, Gecko, Inkscape and many, many others.

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

Squib requires Ruby 2.0 or later.

Install it yourself with:

    $ gem install squib

If you're using Bundler, add this line to your application's Gemfile:

    gem 'squib'

And then execute:

    $ bundle

Note: Squib has some native dependencies, such as [Cairo](https://github.com/rcairo/rcairo), [Pango](http://ruby-gnome2.sourceforge.jp/hiki.cgi?Pango%3A%3ALayout), and [Nokogiri](http://nokogiri.org/), which may require compiling C code to install. This is usually not painful at all, and is automated through Bundler/RubyGems, but can cause headaches on some setups.
  * Windows: I recommend using the *non-64 bit* RubyInstaller at http://rubyinstaller.org. Some installations will also need DevKit. Currently, Ruby 2.2 on Windows conflicts with one of Squib's dependencies called Nokogiri (read the WTF-y issue here: https://github.com/sparklemotion/nokogiri/issues/1256) UPDATE: their pre-releases have fixed this exact issue - just install nokogiri-1.6.7.rc3-x64-mingw32 (or higher). Or, as a last resort, use 2.1 or 2.0 for Windows users.
  * Mac: I recommend using [rvm](https://rvm.io). Some users have reported that Ruby 2.1 will not work with Mac OSX 10.10.4 (#88) - Ruby 2.0 and 2.2 are confirmed to work however (this is an rcairo issue, not a Squib issue).
  * Cywgin is not supported, but could theoretically work with extra installation steps. See [this thread](http://boardgamegeek.com/article/18508113#18508113). Contributions in this area are welcome.
  * Linux. No known installation issues. Happy installing!

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

In addition to this README, be sure to also check out the following resources for more details:

* The `samples` directory in the [source repository](https://github.com/andymeneely/squib) has lots of examples.
* [Iconoclast](https://github.com/andymeneely/iconoclast) is a basic set collection game I'm developing from scratch with Squib. Be sure to read the [commit history](https://github.com/andymeneely/iconoclast/commits/master) to see how the game has developed from scratch.
* [Junk Land](https://github.com/andymeneely/junk-land) is my own creation that's uses Squib for full-color rendering, and makes use of Ruby in a lot of interesting ways.

## Viewing this README

The best place to read this documentation is on [our website](http://andymeneely.github.io/squib/doc). Be sure to check out the method-by-method documentation, particularly for the [Deck](Squib/Deck.html) class.

If you want to view it offline, you can do the following

```sh
$ gem install yard
$ yard server --gems
```
Then go to [http://localhost:8808/docs/squib/file/README.md](http://localhost:8808/docs/squib/file/README.md)

If you're viewing this on Github, you might see some confusing tags like `{include:file:...}` - these are directives for YARD to show the embedded examples. Github doesn't render those and you might find them helpful.

Also, RubyDoc.info linked from RubyGems appears to be perpetually broken and doesn't support `{include:file...}` directive properly, so the embedded samples will also not show up there, either.

## Squib Decks and Cards

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

Under the hood, Squib actually views every argument as applied each card individually. If a single argument is given to the command, it's considered a singleton that gets expanded into a deck-sized array. Supplying the array bypasses that expansion - which means that any array you supply instead of a singleton ought to be the same size as the deck and align the same way the indexes in the supplied `range` are. If you don't, Ruby will fill that up with nils and not apply the rule across those cards.

## Specifying Ranges

Most public `Deck` methods allow a `range` to be specified as a first parameter. This parameter is used to access an internal `Array` of `Squib::Cards`. This can be an actual Ruby range, or anything that implements `#each` (thus can be an `Enumerable`). Integers are also supported for changing one card only. Negatives work from the back of the deck. Here are some examples from `samples/ranges.rb` found [here](https://github.com/andymeneely/squib/tree/master/samples/ranges.rb)

{include:file:samples/ranges.rb}

## Units

By default, Squib thinks in pixels. This decision was made so that we can have pixel-perfect layouts without automatically scaling everything, even though working in units is sometimes easier. We provide some conversion methods, including looking for strings that end in "in" and "cm" and computing based on the current DPI. The dpi is set on `Squib::Deck.new` (not `config.yml`). Example is in `samples/units.rb` found [here](https://github.com/andymeneely/squib/tree/master/samples/units.rb)

{include:file:samples/units.rb}

## Specifying Colors & Gradients

Colors can be specified in a wide variety of ways, mostly in a hex-string. Take a look at the examples from `samples/colors.rb`, found [here](https://github.com/andymeneely/squib/tree/master/samples/colors.rb)

{include:file:samples/colors.rb}

Under the hood, Squib uses the `rcairo` [color parser](https://github.com/rcairo/rcairo/blob/master/lib/cairo/color.rb) to accept a variety of color specifications, along with over [300 pre-defined constants](https://github.com/rcairo/rcairo/blob/master/lib/cairo/colors.rb). The above sample will generate a table of such constants.

Additionally, in most places where colors are allowed, you may also supply a string that defines a gradient. Squib supports two flavors of gradients: linear and radial. Gradients are specified by supplying some xy coordinates, which are relative to the card (not the command). Each stop must be between 0.0 and 1.0, and you can supply as many as you like. Colors can be specified as above (in any of the hex notations or built-in constant). If you add two (or more) colors at the same stop, then the gradient keeps the colors in the in order specified and treats it like sharp transition.

The format for gradient strings look like this:

Linear:
```
(x1,y1)(x2,y2) color1@stop1 color2@stop2
```
The xy coordinates define the angle of the gradient.

Radial:
```
(x1,y1,radius1)(x2,y2,radius2) color1@stop1 color2@stop2
```
The coordinates specify an inner circle first, then an outer circle.

Check out the following sample from `samples/gradients.rb`, found [here](https://github.com/andymeneely/squib/tree/master/samples/colors.rb)

{include:file:samples/gradients.rb}

## Specifying Files

All files opened for reading or writing (e.g. for `png` and `xlsx`) are opened relative to the current directory. Files opened for writing (e.g. for `save_png`) will be overwritten without warning.

If you find that you `cd` a lot while working on the command line, your `_output` folder might get generated in multiple places. An easy way to fix this is to use a `Rakefile`, [see below](#Rakefile)

## Working with Text
The `text` method is a particularly powerful method with a ton of options. Be sure to check the [API docs](/squib/doc/Squib/Deck#text-instance_method) on an option-by-option discussion, but here are the highlights.

###Fonts.

To set the font, your `text` method call will look something like this:

```ruby
text str: "Hello", font: 'MyFont Bold 32'
```

The `'MyFont Bold 32'` is specified as a "Pango font string", which can involve [a lot of options](http://ruby-gnome2.osdn.jp/hiki.cgi?Pango%3A%3AFontDescription#Pango%3A%3AFontDescription.new) including backup font families, size, all-caps, stretch, oblique, italic, and degree of boldness. (These options are only available if the underlying font supports them, however.) Here's are some `text` calls with different Pango font strings:

```
text str: "Hello", font: 'Sans 18'
text str: "Hello", font: 'Arial,Verdana weight=900 style=oblique 36'
text str: "Hello", font: 'Times New Roman,Sans 25'
```

Note: When the font has a space in the name (e.g. Times New Roman), you'll need to put a backup to get Pango's parsing to work.

It's also important to note that most of the font rendering is done by a combination of your installed fonts, your OS, and your graphics card. Thus, different systems will render text slightly differently.

Fonts can also be set globally using the `set` method. For example:

```
set font: 'Arial 26'
text str: 'blah' # in Arial 26
```

Furthermore, Squib's `text` method has options such as `font_size` that allow you to override the font string. This means that you can set a blanket font for the whole deck, then adjust sizes from there. This is useful with layouts and `extends` too.

### Width and Height

By default, Pango text boxes will scale the text box to whatever you need, hence the `:native` default. However, for most of the other customizations to work (e.g. center-aligned) you'll need to specify the width. If both the width and the height are specified and the text overflows, then the `ellipsize` option is consulted to figure out what to do with the overflow. Also, the `valign` will only work if `height` is also set to something other than `:native`.

###Hints

Laying out text by typing in numbers can be confusing. What Squib calls "hints" is merely a rectangle around the text box. Hints can be turned on globally in the config file, using the `set` method, or in an individual text method. These are there merely for prototyping and are not intended for production. Additionally, these are not to be conflated with "rendering hints" that Pango and Cairo mention in their documentation.

###Extents

Sometimes you want size things based on the size of your rendered text. For example, drawing a rectangle around card's title such that the rectangle perfectly fits. Squib returns the final rendered size of the text so you can work with it afterward. It's an array of hashes that correspond to each card. The output looks like this:

```ruby
Squib::Deck.new(cards: 2) do
  extents = text(str: ['Hello', 'World!'])
  p extents
end
```
Will output:
```
[{:width=>109, :height=>55}, {:width=>142, :height=>55}] # Hello was 109 pixels wide, World 142 pixels
```

###Embedding Images

Squib can embed icons into the flow of text. To do this, you need to define text keys for Squib to look for, and then the corresponding files. The object given to the block is a [TextEmbed](docs/Squib/TextEmbed), which supports PNG and SVG. Here's a minimal example:

```ruby
text(str: 'Gain 1 :health:') do |embed|
  embed.svg key: ':health:', file: 'heart.svg'
end
```

###Markup

If you want to do specialized formatting within a given string, Squib has lots of options. By setting `markup: true`, you enable tons of text processing. This includes:

  * Pango Markup. This is an HTML-like formatting language that specifies formatting inside your string. Pango Markup essentially supports any formatting option, but on a letter-by-letter basis. Such as: font options, letter spacing, gravity, color, etc. See the [Pango docs](https://developer.gnome.org/pango/stable/PangoMarkupFormat.html) for details.
  * Quotes are converted to their curly counterparts where appropriate (i.e. &ldquo;smart quotes&rdquo; instead of "straight quotes").
  * Apostraphes are converted to curly as well.
  * LaTeX-style quotes are explicitly converted (<tt>``like this''</tt>)
  * Em-dash and en-dash are converted with triple and double-dashes respectively (<tt>--</tt> is an en-dash, and <tt>---</tt> becomes an em-dash.)
  * Ellipses can be specified with <tt>...</tt>. Note that this is entirely different from the `ellipsize` option (which determines what to do with overflowing text).

A few notes:
  * Smart quoting assumes the UTF-8 character set.
  * Pango markup uses an XML/HTML-ish processor. Some characters require HTML-entity escaping (e.g. `&amp;` for `&')

### Text Sample
```yaml
  lsquote: "\u2018" #note that Yaml wants double quotes here to use escape chars
  rsquote: "\u2019"
  ldquote: "\u201C"
  rdquote: "\u201D"
  em_dash: "\u2014"
  en_dash: "\u2013"
  ellipsis: "\u2026"
```

You can also disable the auto-quoting mechanism by setting `smart_quotes: false` in your config. Explicit replacements will still be performed.

### Text Samples

Examples of all of the above are crammed into the `text_options.rb` sample [found here](https://github.com/andymeneely/squib/tree/master/samples/text_options.rb).

{include:file:samples/text_options.rb}

The `embed_text.rb` sample has more examples of embedding text, which can be [found here](https://github.com/andymeneely/squib/tree/master/samples/embed_text.rb).

{include:file:samples/embed_text.rb}

The `config_text_markup.rb` sample demonstrates how quoting can be configured, [found here](https://github.com/andymeneely/squib/tree/master/samples/config_text_markup.rb)

{include:file:samples/config_text_markup.rb}


## Custom Layouts

Working with x-y coordinates all the time can be tiresome, and ideally everything in a game prototype should be data-driven and easily changed. For this, many Squib methods allow for a `layout` to be set. In essence, layouts are a way of setting default values for any argument given to the command.

To use a layout, set the `layout:` option on a `Deck.new` command to point to a YAML file. Any command that allows a `layout` option can be set with a Ruby symbol or String, and the command will then load the specified `x`, `y`, `width`, and `height`. The individual command can also override these options.

Instead of this:
```ruby
# deck.rb
Squib::Deck.new(layout: 'custom-layout.yml') do
  rect x: 75, y: 75, width: 675, height: 975
end
```

You can put your logic in the layout file and reference them:
```yaml
# custom-layout.yml
frame:
  x: 75
  y: 75
  width: 975
  height: 675
```
Then your script looks like this:
```ruby
# deck.rb
Squib::Deck.new(layout: 'custom-layout.yml') do
  rect layout: 'frame'
end
```
The goal is to make your Ruby code more separate data from logic, which in turn makes your code more readable and maintainable. With `extends` (see below), layouts become even more powerful in keeping you from repeating yourself.

Note: YAML is very finnicky about not allowing tab characters. Use two spaces for indentation instead. If you get a `Psych` syntax error, this is likely the culprit. Indendation is also strongly enforced in Yaml too. See the [Yaml docs](http://www.yaml.org/YAML_for_ruby.html).

### Order of Precedence

Layouts will override Squib's system defaults, but are overriden by anything specified in the command itself. Thus, the order of precedence looks like this:

* Use what the command specified
* If anything was not yet specified, use what was given in a layout (if a layout was specified in the command and the file was given to the Deck)
* If still anything was not yet specified, use what was given in Squib's defaults.

### Special key: `extends`

Squib provides a way of reusing layouts with the special `extends` key. When defining an `extends` key, we can merge in another key and modify data coming in if we want to. This allows us to do things like place text next to an icon and be able to move them with each other. Like this:

```yaml
# If we change the xy of attack, we move defend too!
attack:
  x: 100
  y: 100
  radius: 100
defend:
  extends: attack
  x: += 50
  #defend now is {:x => 150, :y => 100}
```

If you want to extend multiple parents, it looks like this:

```yaml
socrates:
  x: 100
plato:
  y: 200
aristotle:
  extends:
    - socrates
    - plato
  x: += 50
```
If multiple keys override the same keys in a parent, the later ("younger") child takes precedent.

Note that extends keys are similar to Yaml's ["merge keys"](http://www.yaml.org/YAML_for_ruby.html#merge_key). With merge keys, you can define base styles in one entry, then include those keys elsewhere. For example:

```yaml
icon: &icon
  width: 50
  height: 50
icon_left
  <<: *icon
  x: 100
# The layout for icon_left will have the width/height from icon!
```

If you use both `extends` and Yaml merge keys, the Yaml merge keys are processed first, then extends. For clarity, however, you're probably just better off using `extends` exclusively.

### Multiple layout files

Squib also supports the combination of multiple layout files. If you provide an `Array` of files then Squib will merge them sequentially. Colliding keys will be completely re-defined by the later file. Extends is processed after _each file_. Here's a complex example:

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
  extends: parent_a  # i.e. extends a layout in a separate file
  x: += 3    # evaluates to 113 (i.e 110 + 3)
parent_b:    # redefined
  extends: grandparent
  x: += 30   # evaluates to 130 (i.e. 100 + 30)
child_b:
  extends: parent_b
  x: += 3    # evaluates to 133 (i.e. 130 + 3)
```

This can be helpful for:
  * Creating a base layout for structure, and one for color (for easier color/black-and-white switching)
  * Sharing base layouts with other designers

YAML merge keys are NOT supported across multiple files - use `extends` instead.

### Built-in Layout Files

Why mess with x-y coordinates when you're first prototyping your game?!?!? Just use a built-in layout to get your game to the table as quickly as possible.

If your layout file is not found in the current directory, Squib will search for its own set of layout files.  The latest the development version of these can be found [on GitHub](https://github.com/andymeneely/squib/tree/master/lib/squib/layouts). The `layouts_builtin.rb` sample (found [here](https://github.com/andymeneely/squib/tree/master/samples/)) demonstrate built-in layouts based on popular games (e.g. `fantasy.yml` and `economy.yml`)

Contributions in this area are particularly welcome!

### Layout Sample
This sample demonstrates many different ways of using and combining layouts. This is the `layouts.rb` sample found [here](https://github.com/andymeneely/squib/tree/master/samples/)

{include:file:samples/layouts.rb}

## Backends: Raster vs. Vector
Under the hood, Cairo has the ability to support a variety of surfaces to draw on, including both raster images stored in memory and vectors stored in SVG files. Thus, Squib supports the ability to handle both. They are options in the configuration file `backend: memory` or `backend: svg`.

If you save to a PDF then the backend will determine how your cards are saved too. For `memory`, the PDF will be filled with compressed raster images and be a larger file (yet it will still print at high quality... see discussion below). For SVG backends, PDFs will be smaller. If you have your deck backed by SVG, then the cards are auto-saved, so there is no `save_svg` in Squib. (Technically, the operations are stored and then flushed to the SVG file at the very end.)

There are trade-offs that one should consider here.

* _Print quality is **higher** for raster images_. This seems counterintuitive at first, but consider where Squib sits in your workflow. It's the final assembly line for your cards before they get printed. Cairo puts _a ton_ of work into rendering each pixel perfectly when it works with raster images. Printers, on the other hand, don't think in vectors and will render your paths in their own memory with their own embedded libraries without putting a lot of work into antialiasing and various other graphical esoterica. You may notice that print-on-demand companies such as The Game Crafter [only accept raster file types](https://www.thegamecrafter.com/help/supported-file-types), because they don't want their customers complaining about printers not rendering vectors with enough care.
* _PDFs are **smaller** for SVG back ends_. If file size is a limitation for you, and it can be for some printers or internet forums, then an SVG back end for vectorized PDFs is the way to go.
* _Squib is **greedy** with memory_. While I've tested Squib with big decks on older computers, the `memory` backend is quite greedy with RAM. If memory is at a premium for you, switching to SVG might help.

Note: you can still load PNGs into an SVG-backed deck and load SVGs into a memory-backed deck. To me, the sweet spot is to keep all of my icons, text, and other stuff in vector form for infinite scaling and then render them all to pixels with Squib.

Fortunately, switching backends in Squib should be as trivial as changing the setting in the config file. So go ahead and experiment with both and see what works for you. See below for how the configuration options work.

## Configuration File

Squib supports various configuration properties that can be specified in an external file. The `config:` option in `Deck.new` can specify an optional configuration file in YML format. The properties there are intended to be immutable for the life of the Deck. The options include:

* `progress_bars` (Boolean, default: false).  When set to `true`, long-running operations will show a progress bar on the command line.
* `hint` (ColorString, default: off). Text hints are used to show the boundaries of text boxes. Can be enabled/disabled for individual commands, or set globally with the `set` command. This setting is overriden by `set` and individual commands.
* `custom_colors` (Hash of Colors, default: {}). Defines globally-available colors available to the deck that can be specified in commands.
* `antialias` (`fast, good, best, none, gray, subpixel`, default: best). Set the algorithm that Cairo will use for antialiasing. Using our benchmarks on large decks, `best` is only ~10% slower anyway. For more info see the [Cairo docs](http://www.cairographics.org/manual/cairo-cairo-t.html#cairo-antialias-t).
* `backend` (`svg` or `memory`, default: `memory`). Defines how Cairo will store the operations. Memory is recommended for higher quality rendering.
* `prefix` (default: `card_`). When using an SVG backend, cards are auto-saved with this prefix and `"%02d"` numbering format.
* `warn_ellipsize` (default: true). Warn when text is ellipsized
* `warn_png_scale` (default: true). Warn when a PNG file is upscaled

For debugging/sanity purposes, if you want to make sure your configuration options are parsed correclty, the above options are also available as methods within Squib::Deck, for example:

```ruby
Squib::Deck.new do
  puts backend # prints 'memory' by default
end
```

The following sample demonstrates the config file, found [here](https://github.com/andymeneely/squib/tree/master/samples/)

{include:file:samples/custom_config.rb}

## Importing from Excel and CSV

Squib supports importing data from `xlsx` files and `csv` files. These methods are column-based, which means that they assume you have a header row in your table, and that header row will define the column. Squib will return a `Hash` of `Arrays` correspoding to each row. Warnings are thrown on things like duplicate columns. See the `excel.rb` and the `csv_import.rb` sample found [here](https://github.com/andymeneely/squib/tree/master/samples/).

{include:file:samples/excel.rb}

Of course, you can always import your game data other ways using just Ruby. There's nothing special about Squib's methods other than their convenience.

###Quantity Explosion

If you want more than one copy of a card, then have a column called `Qty` and fill it with counts. Squib's `xlsx` and `csv` methods will automatically expand those rows according to those counts. You can also customize that "Qty" to anything you like by setting the `explode` option (e.g. `explode: 'Quantity'`). See the `excel.rb` and the `csv_import.rb` samples found [here](https://github.com/andymeneely/squib/tree/master/samples/) for an example.

## Making Squib Verbose

By default, Squib's logger is set to WARN, but more fine-grained logging is embedded in the code. To set the logger, just put this at the top of your script:

```ruby
Squib::logger.level = Logger::INFO
```

If you REALLY want to see tons of output, you can also set DEBUG, but that's not intended for general consumption.

# "Best" Practices

Here's a collection of workflow tips and code snippets that will hopefully improve your Squibbing. Contributions are welcome!

## Staying DRY

Squib tries to keep you DRY (Don't Repeat Yourself) with the following features:

* Custom layouts allow you to specify various arguments in a separate file. This is great for x-y coordinates and alignment properties that would otherwise clutter up perfectly readable code. Squib goes even further and has a special "extends" that works especially well for grouped-together styles.
* Flexible ranges and array handling: the `range` parameter in Squib is very flexible, meaning that one `text` command can specify different text in different fonts, styles, colors, etc. for each card. If you find yourself doing multiple `text` command for the same field across different ranges of cards, there's probably a better way to condense.
* Custom colors keep you from hardcoding magic color strings everywhere. Custom colors go into `config.yml` file.
* Plus, you know, Ruby.

## Get to know Ruby's Array and Enumerable

Don't know Ruby? Welcome! We are so happy that Squib is your excuse to learn Ruby.

Ruby has a *very* rich library for all of its built-in data types, especially [Array](http://ruby-doc.org/core-2.2.0/Array.html), and it's broader module [Enumerable](http://ruby-doc.org/core-2.2.0/Enumerable.html). Since Squib primarily takes in arrays into most of its fields, getting to know these methods will help you out enormously:

  * [Array#each](http://ruby-doc.org/core-2.2.0/Array.html#method-i-each) - do something on each element of the array (Ruby folks seldom use for-loops)
  * [Array#map](http://ruby-doc.org/core-2.2.0/Array.html#method-i-map) - do something on each element of an array and put it into a new array
  * [Array#select](http://ruby-doc.org/core-2.2.0/Array.html#method-i-select) - select a subset of an array
  * [Enumerable#each_with_index](http://ruby-doc.org/core-2.2.0/Enumerable.html#method-i-each_with_index) - do something to each element, also being aware of the index
  * [Array#zip](http://ruby-doc.org/core-2.2.0/Enumerable.html#method-i-zip) - combine two arrays, element by element

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

When you run `squib new`, you are given a basic Rakefile. At this stage of Squib, it's basically just a shortcut for `ruby deck.rb`. But, even in this simple form this Rakefile has some advantages:

* If you're in a subdirectory at the time, `rake` will simply traverse up and `cd` to the proper directory so you don't get rogue `_output` directories
* If you find yourself building multiple decks, you can make your own tasks for each one individually, or all (e.g. `rake marketing`)
* Don't need the `require squib` at the top of your code (although that breaks `ruby deck.rb`, so that's probably a bad idea)

## Using Google Sheets

We don't officially support Google Sheets ([yet](https://github.com/andymeneely/squib/issues/49)), but [this Gist](https://gist.github.com/pickfifteen/aeee73ec2ce162b0aee8) might be helpful in automatically exporting the CSV.

## Combining Multiple Columns

Say you have multiple columns in your Excel sheet that need to be combined into one text field on your card. Consider using `zip` in conjunction with `map`.

```ruby
data['BuyText'] = data['BuyAmount'].zip(data['BuyType']).map do |amt, type|
  "You may purchase #{amt} #{type}" #e.g. You may purchase 1 Wood.
end

data['Cost'] = data['Action Cost'].zip(data['Card Cost']).map do |ac, cc|
  ':action:' * ac.to_i + ":card#{cc}:"
end
```

Second example adapted from [this conversation](https://github.com/andymeneely/squib/issues/90)

# Get Involved

Squib is an open source tool, so I welcome participation. Squib is currently in pre-release alpha, so the API is still maturing. I do change my mind about the names and meaning of things at this stage. I will document these changes as best as I can.

I also highly recommend upgrading to new versions of Squib every chance you get (using Bundler). You can watch for new upgrades by following the RubyGems [RSS](https://rubygems.org/gems/squib/versions.atom), or by watching the project on GitHub.

For bugs and feature requests, feel free to [file a bug or feature request](https://github.com/andymeneely/squib/issues). A minimal code example along with your OS and Ruby details would be ideal.

## New to Programming?

I often hear statements like "I'm not a programmer, but I want to use Squib." If you want to use Squib, then maybe you really were a programmer all along :)

Squib is a Ruby library. To learn Squib, you will need to learn Ruby. There is no getting around that fact. Don't fight it, embrace it.

Fortunately, Ruby is wonderfully rich in features and very expressive in its syntax. Ruby has a vibrant, friendly community (much like tabletop game designers!). Ruby is the language of choice for many new programmers, including many universities. Plus, learning how to code is ubiquitous on the Internet.

Doubly fortunately, Squib doesn't require tons of Ruby-fu to get going either. The main things you'll need to know are:
  * Working on the command line
  * Ruby Arrays, so that the `range` parameter makes more sense
  * Strings, variables, and symbols
  * If you are using Excel or CSV, then Ruby hashes are worth a glance.
  * Working iteratively: making small edits and run your code frequently (every few minutes)

Anything related to Ruby on Rails is not necessary to learn for Squib. Rails is a heavyweight framework for web development (awesome in its own way, but not relevant to learning Ruby). Squib is about scripting.

## Get Help

There are lots of people using Squib already. If you've gone through the [samples](https://github.com/andymeneely/squib/tree/master/samples) and still have questions, here are some other places to get help.

* Our [thread on BoardGameGeek](http://boardgamegeek.com/thread/1293453) is quite active and informal (if a bit unstructured).
* [StackOverflow](http://stackoverflow.com/questions/ask?tags=ruby squib) with the tag "ruby" and "squib" will get you answers quickly and a great way to document questions for future Squibbers.

If you email me directly I'll probably ask you to post your question publicly so we can document answers for future Googling Squibbers.

Please use GitHub issues for bugs and feature requests.

## Give Help

Let's help each other out! Even if you're relatively new, there's probably some question out there that you can help answer. Here's how to help:

* Subscribe to our thread on BoardGameGeek (see above for link)
* Subscribe to alerts from Stackoverflow for the tags "squib" and "ruby"
* Post snippets of your code using GitHub gists
* Write a how-to tutorial and post it on [our wiki](https://github.com/andymeneely/squib/wiki)

## Testing Pre-Builds

Testers needed!! If you want to test new features as I develop them, or make sure I didn't break your code, you can always point your Gemfile to the repository and follow what I'm doing there. Your Gemfile specification looks like this:

```ruby
gem 'squib', git: 'git://github.com/andymeneely/squib', branch: 'dev'
```
* The `dev` branch is where I am working on features in-process. I have not done much regression testing at this point, but would love testing feedback nonetheless.
* The `master` branch is where I consider features and bug that are done and tested, but not released yet.

## Contributing

If you want your code integrated:

1. Fork the git repository ( https://github.com/[my-github-username]/squib/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

Be sure to run the unit tests and packaging with just `rake`. Also, you can check that the samples render properly with `rake sanity`.

# What's up the with the name?

Truthfully, I just thought it was a cool, simple word that was not used much in the Ruby community nor the board game community. But, now that I've committed to the name, I've realized that:

* Squibs are small explosive devices, much like Squib "explodes" your rules into a playable game
* Squibs are often used in heist movies, leading to a sudden plot twist that often resembles the twists of good tabletop game
* Squibs are also part of the Harry Potter world - they are people who are non-magical but wizard-born. Squib is aware of wizarding magic and comes from that heritage, but it's not magical itself.
