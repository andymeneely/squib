# Squib [![Gem Version](https://badge.fury.io/rb/squib.svg)](https://rubygems.org/gems/squib) [![Build Status](https://secure.travis-ci.org/andymeneely/squib.svg?branch=master)](https://travis-ci.org/andymeneely/squib) [![Build status](https://ci.appveyor.com/api/projects/status/ptjw6fvjh73anlau/branch/master?svg=true)](https://ci.appveyor.com/project/andymeneely/squib/branch/master) [![Dependency Status](https://gemnasium.com/andymeneely/squib.svg)](https://gemnasium.com/andymeneely/squib) [![Coverage Status](https://img.shields.io/coveralls/andymeneely/squib.svg)](https://coveralls.io/r/andymeneely/squib) [![ReadTheDocs](https://readthedocs.org/projects/squib/badge/?version=latest)](http://squib.readthedocs.io/en/latest/?badge=latest) [![BoardGameGeek](https://cdn.rawgit.com/andymeneely/squib/gh-pages/images/microbadge.png)](https://boardgamegeek.com/guild/2601)

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

Wanna see more? Check out the website: http://andymeneely.github.io/squib/

## Installation

Squib requires Ruby 2.0 or later.

Install it yourself with:

    $ gem install squib

If you're using Bundler, add this line to your application's Gemfile:

    gem 'squib'

And then execute:

    $ bundle

More info: http://squib.readthedocs.org/en/latest/install.html


## Getting Started

After installing Squib, you can create a project and run your first build like this:

```sh
$ squib new my-cool-game
$ cd my-cool-game
$ ruby deck.rb
```

The `squib new` command will generate files and folders like this:

```
├── .gitignore
├── ABOUT.md
├── Gemfile
├── IDEAS.md
├── PLAYTESTING.md
├── PNP NOTES.md
├── RULES.md
├── Rakefile
├── _output
│   └── gitkeep.txt
├── config.yml
├── deck.rb
└── layout.yml

12 files
```


# Learning Squib

Go [read the docs!](http://squib.readthedocs.org/)

Also:
* The `samples` directory in the [source repository](https://github.com/andymeneely/squib) has lots of examples.
* [Your Last Heist](http://yourlastheist.com) is my own creation, and it was made with Squib. Go through the repository and watch how it evolved!
* [Junk Land](https://github.com/andymeneely/junk-land) is my own creation that's uses Squib for full-color rendering, and makes use of Ruby in a lot of interesting ways. The port is still in process.
* [Project Spider Monkey](https://github.com/andymeneely/project-spider-monkey) is another of my own creations. This one was started from scratch with Squib, but it's still in its early stages.


## Staying DRY

Squib tries to keep you DRY (Don't Repeat Yourself) with the following features:

* Custom layouts allow you to specify various arguments in a separate file. This is great for x-y coordinates and alignment properties that would otherwise clutter up perfectly readable code. Squib goes even further and has a special "extends" that works especially well for grouped-together styles.
* Flexible ranges and array handling: the `range` parameter in Squib is very flexible, meaning that one `text` command can specify different text in different fonts, styles, colors, etc. for each card. If you find yourself doing multiple `text` command for the same field across different ranges of cards, there's probably a better way to condense.
* Custom colors keep you from hardcoding magic color strings everywhere. Custom colors go into `config.yml` file.
* Plus, you know, Ruby.

## SublimeText

Using SublimeText? I like you already. I've written up some Squib snippets to ease remembering Squib commands. It's called `Squib Snippets` on Package Control. Compatible with SublimeText 3. Source code is also [on Github](https://github.com/andymeneely/sublime-squib) (contributions welcome!). Check it out:

![Sublime Squib Snippets](https://raw.githubusercontent.com/andymeneely/squib/screencasts/sublime-squib-snippets.gif)



# Get Help and Give Help

See [this page](http://squib.readthedocs.org/en/latest/help.html)


# What's up the with the name?

Truthfully, I just thought it was a cool, simple word that was not used much in the Ruby community nor the board game community. But, now that I've committed to the name, I've realized that:

* Squibs are small explosive devices, much like Squib "explodes" your rules into a playable game
* Squibs are often used in heist movies, leading to a sudden plot twist that often resembles the twists of good tabletop game
* Squibs are also part of the Harry Potter world - they are people who are non-magical but wizard-born. Squib is aware of wizarding magic and comes from that heritage, but it's not magical itself.
