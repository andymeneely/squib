# Squib [![Gem Version](https://badge.fury.io/rb/squib.svg)](https://rubygems.org/gems/squib) [![Build Status](https://secure.travis-ci.org/andymeneely/squib.svg?branch=master)](https://travis-ci.org/andymeneely/squib) [![Dependency Status](https://gemnasium.com/andymeneely/squib.svg)](https://gemnasium.com/andymeneely/squib)

Squib is a Ruby DSL for prototyping card and board games. Think of it like [nanDeck](http://www.nand.it/nandeck/) done "the Ruby way". Start with some basic commands and generate print-ready PNGs and PDFs. Squib supports:

* Complex text rendering using [Pango](http://www.pango.org/)
* Reading PNGs and SVGs using [Cairo](http://cairographics.org/)
* Reading `.xlsx` files
* Basic shape drawing
* Saving to PNGs and PDFs
* Plus the full power of Ruby! 

```ruby
require 'squib'

Squib::Deck.new do
  text str: 'Hello, World!'  
  save_png
end
```

## Installation

Add this line to your application's Gemfile:

    gem 'squib'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install squib

Note: Squib has some native dependencies, such as [Cairo](https://github.com/rcairo/rcairo), [Pango](http://ruby-gnome2.sourceforge.jp/hiki.cgi?Pango%3A%3ALayout), and [Nokogiri](http://nokogiri.org/), which all require DevKit to compile C code. This is usually not painful, but on some setups can cause headaches. For Windows users, I *strongly* recommend using the *non-*64 bit RubyInstaller at http://rubyinstaller.org/

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

The central file here is `deck.rb`. Here's a more complex example of a deck to work from:

```ruby
require 'squib'

Squib::Deck.new(width: 825, height: 1125, cards: 3) do
  background color: :white
  data = xlsx file: 'sample.xlsx'

  rect x: 15, y: 15, width: 795, height: 1095, x_radius: 50, y_radius: 50

  text str: data['name'], x: 250, y: 55, font: 'Arial 54'
  text str: data['level'], x: 65, y: 40, font: 'Arial 72'

  png file: 'icon.png', x: 665, y: 30

  save format: :png
end
```

## Learning Squib's API

* The `samples` directory in the [source repository](https://github.com/andymeneely/squib) has lots of examples
* The [API.md]() walks through the various methods and options
* [API Documentation](http://rubydoc.info/gems/squib/) is also kept up-to-date.

## Development

Squib is currently in pre-release alpha, so the API is still maturing. If you are using Squib, however, I'd love to hear about it! Feel free to [file a bug or feature request](https://github.com/andymeneely/squib/issues).

## Contributing

Squib is an open source tool, and I would love participation. If you want your code integrated:

1. Fork it ( https://github.com/[my-github-username]/squib/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
