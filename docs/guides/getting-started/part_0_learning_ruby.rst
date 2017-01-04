The Squib Way pt 0: Learning Ruby
====================================

This guide is for folks who are new to coding and/or Ruby. Feel free to skip it if you already have some coding experience.

Not a Programmer?
-----------------

   `I'm not a programmer, but I want to use Squib. Can you make it easy for non-programmers?`

   -- `Frequently Asked Question`

If you want to use Squib, then you want to automate the graphics generation of a tabletop game in a data-driven way. You want to be able to change your mind about icons, illustrations, stats, and graphic design - then rebuild your game with a just a few keystrokes. Essentially, you want to give a list of instructions to the computer, and have it execute your bidding.

If you want those things, then I have news for you. I think you *are* a programmer... who just needs to learn some coding. And maybe Squib will finally be your excuse!

Squib is a Ruby library. To learn Squib, you will need to learn Ruby. There is no getting around that fact. Don't fight it, embrace it.

Fortunately, Squib doesn't really require tons of Ruby-fu to get going. You can really just start from the examples and go from there. And I've done my best to keep to Ruby's own philosophy that programming in it should be a delight, not a chore.

Doubly fortunately,

  * Ruby is wonderfully rich in features and expressive in its syntax.
  * Ruby has a vibrant, friendly community with people who love to help. I've always thought that Ruby people and board game people would be good friends if they spent more time together.
  * Ruby is the language of choice for many new programmers, including many universities.
  * Ruby is also "industrial strength", so it really can do just about anything you need it to.

Plus, resources for learning how to code are ubiquitous on the Internet.

In this article, we'll go over some topics that you will undoubtedly want to pick up if you're new to programming or just new to Ruby.

What You DON'T Need To Know about Ruby for Squib
------------------------------------------------

Let's get a few things out of the way. When you are out there searching the interwebs for solutions to your problems, you will *not* need to learn anything about the following things:

  * **Rails**. Ruby on Rails is a heavyweight framework for web development. It's awesome in its own way, but it's not relevant to learning Ruby as a language by itself. Squib is about scripting, and will never (NEVER!) be a web app.
  * **Object-Oriented Programming**. While OO is very important for developing long-term, scalable applications, some of the philosophy around "Everything in Ruby is an object" can be confusing to newcomers. It's not super-important to grasp this concept for Squib. This means material about classes, modules, mixins, attributes, etc. are not really necessary for Squib scripts. (Contributing to Squib, that's another matter - we use OO a lot internally.)
  * **Metaprogramming**. Such a cool thing in Ruby... don't worry about it for Squib. Metaprogramming is for people who literally sleep better at night knowing their designs are extensible for years of software development to come. You're just trying to make a game.

What You Need to Know about Ruby for Squib
------------------------------------------

I won't give you an introduction to Ruby - other people do that quite nicely (see Resources at the bottom of this article). Instead, as you go through learning Ruby, you should pay special attention to the following:

  * Comments
  * Variables
  * `require`
  * What `do` and `end` mean
  * Arrays, particularly since most of Squib's arguments are usually Arrays
  * Strings and symbols
  * String interpolation
  * Hashes are important, especially for Excel or CSV importing
  * Editing Yaml. Yaml is not Ruby *per se*, but it's a data format common in the Ruby community and Squib uses it in a couple of places (e.g. layouts and the configuration file)
  * Methods are useful, but not immediately necessary, for most Squib scripts.

If you are looking for some advanced Ruby-fu, these are useful to brush up on:

  * ``Enumerable`` - everything you can do with iterating over an Array, for example
  * ``map`` - convert one Array to another
  * ``zip`` - combine two arrays in parallel
  * ``inject`` - process one Enumerable and build up something else

Find a good text editor
-----------------------

The text editor is a programmer's most sacred tool. It's where we live, and it's the tool we're most passionate (and dogmatic) about. My personal favorite editors are `SublimeText <http://www.sublimetext.com/3>`_ and `Atom <http://atom.io>`_. There are a bajillion others. The main things you'll need for editing Ruby code are:

  * Line numbers. When you get an error, you'll need to know where to go.
  * Monospace fonts. Keeping everything lined up is important, especially in keeping indentation.
  * Syntax highlighting. You can catch all kinds of basic syntax mistakes with syntax highlighting. My personal favorite syntax highlighting theme is Monokai.
  * Manage a directory of files. Not all text editors support this, but Sublime and Atom are particularly good for this (e.g. `Ctrl+P` can open anything!). Squib is more than just the deck.rb - you've got layout files, a config file, your instructions, a build file, and a bunch of other stuff. Your editor should be able to pull those up for you in a few keystrokes so you don't have to go all the way over to your mouse.

There are a ton of other things that these editors will do for you. If you're just starting out, don't worry so much about customizing your editor just yet. Work with it for a while and get used to the defaults. After 30+ hours in the editor, only then should you consider installing plugins and customizing options to fit your preferences.

Command line basics
-------------------

Executing Ruby is usually  done through the command line. Depending on your operating system, you'll have a few options.

  * On Macs, you've got the Terminal, which is essentially a Unix shell in Bash (Bourne-Again SHell). This has an amazing amount of customization possible with a long history in the Linux/Unix/BSD world.
  * On Windows, there's the Command Prompt (Windows Key, `cmd`). It's a little janky, but it'll do. I've developed Squib primarily in Windows using the Command Prompt.
  * If you're on Linux/BSD/etc, you undoubtedly know what the command line is.

For example:

.. code-block:: none

  $ cd c:\game-prototypes
  $ gem install squib
  $ squib new tree-gnome-blasters
  $ ruby deck.rb
  $ rake
  $ bundle install
  $ gem up squib

This might seem arcane at first, but the command line is the single most powerful and expressive tool in computing... if you know how to harness it.

Edit-Run-Check.
---------------

To me, the most important word in all of software development is *incremental*. When you're climbing up a mountain by yourself, do you wait to put in anchors until you reach the summit? No!! You anchor yourself along the way frequently so that when you fall, you don't fall very far.

In programming, you need to be running your code often. Very often. In an expressive language like Ruby, you should be running your code every 60-90 seconds (seriously). Why? Because if you make a mistake, then you know that you made it in the last 60-90 seconds, and your problem is that much easier to solve. Solving one bug might take two minutes, but solving three bugs at once will take ~20 minutes (empirical studies have actually backed this up exponentiation effect).

How much code can you write in 60-90 seconds? Maybe 1-5 lines, for fast typists. Think of it this way: the longer you go without running your code, the more debt you're accruing because it will take longer to fix all the bugs you haven't fixed yet.

That means your code should be stable very often. You'll pick up little tricks here and there. For example, whenever you type a ``(``, you should immediately type a ``)`` afterward and edit in the middle (some text editors even do this for you). Likewise, after every ``do`` you should type ``end`` (that's a Ruby thing). There are many, many more. Tricks like that are all about reducing what you have to remember so that you can keep your code stable.

With Squib, you'll be doing one other thing: checking your output. Make sure you have some specific cards to check constantly to make sure the card is coming out the way you want. The Squib method :doc:`/dsl/save_png` (or ones like it) should be one of the first methods you write when you make a new deck.

As a result of all these, you'll have lots of windows open when working with Squib. You'll have a text editor to edit your source code, your spreadsheet (if you're working with one), a command line prompt, and a preview of your image files. It's a lot of windows, I know. That's why computer geeks usually have multiple monitors!

So, just to recap: your edit-run-check cycle should be *very* short. Trust me on this one.


Plan to Fail
------------

If you get to a point where you can't possibly figure out what's going on that means one thing.

You're human.

Everyone runs into bugs they can't fix. Everyone. Take a break. Put it down. Talk about it out loud. And then, of course, you can always :doc:`/help`.

Ruby Learning Resources
-----------------------

Here are some of my favorite resources for getting started with Ruby. A lot of them assume you are also new to programming in general. They do cover material that isn't very relevant to Squib, but that's okay - learning is never wasted, only squandered.

`CodeSchool's TryRuby <https://www.codeschool.com/courses/try-ruby>`_
  This is one of my favorites. It's pretty basic but it walks you through the exercises interactively and makes good use of challenges.

`RubyMonk.com <https://rubymonk.com/>`_
  An interactive explanation through Ruby. Gets a bit philosophical, but hey, what else would you expect from a monk?

`Pragmatic Programmer's Guide to Ruby (The PickAxe Book) <http://ruby-doc.com/docs/ProgrammingRuby/>`_
  One of the best comprehensive resources out there for Ruby - available for free!

`Ruby's Own Website: Getting Started <https://www.ruby-lang.org/en/documentation/quickstart/>`_
  This will take you through the basics of programming in Ruby. It works mostly from the Interactive Ruby shell `irb`, which is pretty helpful for seeing how things work and what Ruby syntax looks like.

`Why's Poignant Guide to Ruby <http://poignant.guide/>`_
  No list of Ruby resources is complete without a reference to this, well, poignant guide to Ruby. Enjoy.

`The Pragmatic Programmer <http://www.amazon.com/The-Pragmatic-Programmer-Journeyman-Master/dp/020161622X>`_
  The best software development book ever written (in my opinion). If you are doing programming and you have one book on your shelf, this is it. Much of what inspired Squib came from this thinking.
