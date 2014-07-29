# Squib [![Gem Version](https://badge.fury.io/rb/squib.svg)](https://rubygems.org/gems/squib) [![Build Status](https://secure.travis-ci.org/andymeneely/squib.svg?branch=master)](https://travis-ci.org/andymeneely/squib) [![Dependency Status](https://gemnasium.com/andymeneely/squib.svg)](https://gemnasium.com/andymeneely/squib) [![Coverage Status](https://img.shields.io/coveralls/andymeneely/squib.svg)](https://coveralls.io/r/andymeneely/squib) [![Inline docs](http://inch-ci.org/github/andymeneely/squib.png?branch=master)](http://inch-ci.org/github/andymeneely/squib)
Squib is a Ruby [DSL](http://en.wikipedia.org/wiki/Domain-specific_language) for prototyping card and board games. With Squib, you just write a little bit of Ruby and you can compile your game's data and images into a series of images raedy for print-and-play or even print-on-demand. Squib is very data-driven - think of it like [nanDeck](http://www.nand.it/nandeck/) done "the Ruby way". Squib currently supports:

* Reading PNGs and SVGs using [Cairo](http://cairographics.org/)
* Complex text rendering using [Pango](http://www.pango.org/)
* Reading `.xlsx` files
* Basic shape drawing
* Rendering to PNGs and PDFs
* Unit conversion (inches)
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

The central file here is `deck.rb`. Here's a basic example of a deck to work from:

{include:file:samples/basic.rb basic.rb}

## Learning Squib

After going over this README, here are some other places to go learn Squib:

* The YARD-generated API documentation [for the latest Squib gem](http://rubydoc.info/gems/squib/) is a method-by-method reference. I recommend starting with the `API` file, and looking at the `Deck` class. If you are following Squib master, see [the latest version](http://rubydoc.info/github/andymeneely/squib/frames)
* The `samples` directory in the [source repository](https://github.com/andymeneely/squib) has lots of examples
* Junk Land (link TBD) is my own creation that's uses Squib for both black-and-white print-and-play and full color.

## Development

Squib is currently in pre-release alpha, so the API is still maturing. If you are using Squib, however, I'd love to hear about it! Feel free to [file a bug or feature request](https://github.com/andymeneely/squib/issues).

## Contributing

Squib is an open source tool, and I would love participation. If you want your code integrated:

1. Fork it ( https://github.com/[my-github-username]/squib/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
