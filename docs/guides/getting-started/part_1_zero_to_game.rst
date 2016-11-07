The Squib Way pt 1: Zero to Game
=================================

I've always felt that the Ruby community and the tabletop game design community had a lot in common, and a lot to learn from each other. Both are all about testing. All about iterative development. Both communities are collegial, creative, and fun.

But the Ruby community, and the software development community generally, has a lot to teach us game designers about how to develop something. `Ruby has a "way" of doing things <http://therubyway.io/>`_ that is unique and helpful to game designers.

In this series of guides, I'll introduce you to Squib's key features and I'll walk you through a basic prototype. We'll also take a more circuitous route than normal so that I can touch upon some key design principles and good software development habits so that you can make your Squib scripts maintainable, understandable, flexible, and changeable.

Prototyping with Squib
----------------------

Squib is all about being able to change your mind quickly. Change data, change layout, change artwork, change text. But where do we start? What do we work on first?

The key to prototyping tabletop games is *playtesting*. At the table. With humans. Printed components. That means that we need to get our idea out of our brains and onto pieces of paper as fast as possible.

But! We also want to get the *second* (and third and fourth and fifth...) version of our game back to the playtesting table quickly, too. If we work with Squib from day one, our ability to react to feedback will be much smoother once we've laid the groundwork.


Get Installed and Set Up
-----------------------------
The ordinary installation is like most Ruby gems::

  $ gem install squib

See :doc:`/install` for more details.

This guide also assumes you've got some basic Ruby experience, and you've got your tools set up (i.e. text editor, command line, image preview, etc). See :doc:`part_0_learning_ruby` to see my recommendations.

Our Idea: Familiar Fights
-------------------------
Let's start with an idea for a game: Familiar Fights. Let's say we want to have players fight each other based on collecting cards that represent their familiars, each with different abilities. We'll have two factions: drones and humans. Each card will have some artwork in it, and some text describing their powers.

First thing: the title. It stinks, I know. It's gonna change. So instead of naming the directory after our game and getting married to our bad idea, let's give our game a code name. I like to use animal names, so let's go with Arctic Lemming::

  $ squib new arctic-lemming
  $ cd arctic-lemming
  $ ls
  ABOUT.md	Gemfile		PNP NOTES.md	Rakefile	_output		config.yml	deck.rb		layout.yml

Go ahead and put "Familiar Fights" as an idea for a title in the ``IDEAS.md`` file.

If you're using Git or other version control, now's a good time to commit. See :doc:`/guides/git`.

Data or Layout?
---------------

From a prototyping standpoint, we really have two directions we can work from:

  * Laying out an example card
  * Working on the deck data

There's no wrong direction here - we'll need to do both to get our idea onto the playtesting table. Go where your inspiration guides you. For this example, let's say I've put together ideas for four cards. Here's the data:

======  =======  ===============================
name    faction  power
======  =======  ===============================
Ninja   human    Use the power of another player
Pirate  human    Steal 1 card from another player
Zombie  drone    Take a card from the discard pile
Robot   drone    Draw two cards
======  =======  ===============================

If you're a spreadsheet person, go ahead and put this into Excel (in the above format). Or, if you want to be plaintext-friendly, put it into a comma-separated format (CSV). Like this:

.. raw:: html

  <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
  <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/gist-embed/2.4/gist-embed.min.js"></script>
  <code data-gist-id="d2bb2eb028b27cf1dace" data-gist-file="data.csv"></code>

Initial Card Layout
-----------------------------

Ok let's get into some code now. Here's an "Hello, World" code snippet

.. raw:: html

  <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
  <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/gist-embed/2.4/gist-embed.min.js"></script>
  <code data-gist-id="d2bb2eb028b27cf1dace" data-gist-file="01_hello.rb"></code>

Let's dissect this:

  * Line 1: this code will bring in the Squib library for us to use. Keep this at the top.
  * Line 2: By convention, we put a blank line between our `require` statements and the rest of our code
  * Line 3: Define a new deck of cards. Just 1 card for now
  * Line 4: Set the background to pink. Colors can be in various notations - see :doc:`/colors`.
  * Line 5: Draw a rectangle around the edge of the deck. Note that this has no arguments, because :doc:`/parameters`.
  * Line 6: Put some text in upper-left the corner of the card.
  * Line 7: Save our card out to a png file called ``card_00.png``. Ordinarily, this will be saved to ``_output/card_00.png``, but in our examples we'll be saving to the current directory (because this documentation has its examples as GitHub gists and gists don't have folders - I do not recommend having ``dir: '.'`` in your code)

By the way, this is what's created:

.. raw:: html

  <img src="../../intro/part1_00_expected.png" width=250>

Now let's incrementally convert the above snippet into just one of our cards. Let's just focus on one card for now. Later we'll hook it up to our CSV and apply that to all of our cards.

You may have seen in some examples that we can just put in x-y coordinates into our DSL method calls (e.g. ``text x: 0, y: 100``). That's great for customizing our work later, but we want to get this to the table quickly. Instead, let's make use of Squib's feature (see :doc:`/layouts`).

Layouts are a way of specifying some of your arguments in one place - a layout file. The ``squib new`` command created our own ``layout.yml`` file, but we can also use one of Squib's built-in layout files. Since we just need a title, artwork, and description, we can just use ``economy.yml`` (inspired by a popular deck builder that currently has *dominion* over the genre). Here's how that looks:

.. raw:: html

  <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
  <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/gist-embed/2.4/gist-embed.min.js"></script>
  <code data-gist-id="d2bb2eb028b27cf1dace"
        data-gist-file="02_onecard.rb"></code>
  <code data-gist-id="d2bb2eb028b27cf1dace"
        data-gist-file="02_onecard_rb.png"
        class=code_img
        ></code>


There are a few key decisions I've made here:

  * **Black-and-white**. We're now only using black or white so that we can be printer-friendly.
  * **Safe and Cut**. We added two rectangles for guides based on the poker card template from `TheGameCrafter.com <http://www.thegamecrafter.com>`_. This is important to do now and not later. In most print-on-demand templates, we have a 1/8-inch border that is larger than what is to be used, and will be cut down (called a *bleed*). Rather than have to change all our coordinates later, let's build that right into our prototype. Squib can trim around these bleeds for things like :doc:`/dsl/showcase`, :doc:`/dsl/hand`, :doc:`/dsl/save_sheet`, :doc:`/dsl/save_png`, and :doc:`/dsl/save_pdf`. See :doc:`/bleed`.
  * **Title**. We added a title based on our data.
  * **layout: 'foo'**. Each command references a "layout" rule. These can be seen in our layout file, which is a built-in layout called ``economy.yml`` (see `ours on GitHub <https://github.com/andymeneely/squib/blob/master/lib/squib/layouts/economy.yml>`_ ). Later on, we can define our own layout rules in our own file, but for now we just want to get our work done as fast as possible and make use of the stock layout. See :doc:`/layouts`.

Multiple Cards
--------------
Ok now we've got a basic card. But we only have one. The real power of Squib is the ability to customize things *per card*. So if we, say, want to have two different titles on two different cards, our `text` call will look like this::

  text str: ['Zombie', 'Robot'], layout: 'title'

When Squib gets this, it will:

  * See that the ``str:`` option has an array, and put ``'Zombie'`` on the first card and ``'Robot'`` on the second.
  * See that the ``layout:`` option is NOT an array - so it will use the same one for every card.

So technically, these two lines are equivalent::

  text str: ['Zombie', 'Robot'], layout: 'title'
  text str: ['Zombie', 'Robot'], layout: ['title','title']

Ok back to the game. We COULD just put our data into literal arrays. But that's considered bad programming practice (called *hardcoding*, where you put data  directly into your code). Instead, let's make use of our CSV data file.

What the ``csv`` command does here is read in our file and create a hash of arrays. Each array is a column in the table, and the header to the colum is the key to the hash. To see this in action, check it out on Ruby's interactive shell (``irb``)::

  $ irb
  2.1.2 :001 > require 'squib'
   => true
  2.1.2 :002 > Squib.csv file: 'data.csv'
   => {"name"=>["Ninja", "Pirate", "Zombie", "Robot"], "class"=>["human", "human", "drone", "drone"], "power"=>["Use the power of another player", "Steal 1 card from another player", "Take a card from the discard pile", "Draw two cards"]}

So, we COULD do this::

  require 'squib'

  Squib::Deck.new cards: 4, layout: 'economy.yml' do
    data = csv file: 'data.csv'
    #rest of our code
  end

**BUT!** What if we change the number of total cards in the deck? We won't always have 4 cards (i.e. the number 4 is hardcoded). Instead, let's read in the data outside of our ``Squib::Deck.new`` and then create the deck size based on that::

  require 'squib'

  data = Squib.csv file: 'data.csv'

  Squib::Deck.new cards: data['name'].size, layout: 'economy.yml' do
    #rest of our code
  end

So now we've got our data, let's replace all of our other hardcoded data from before with their corresponding arrays:

.. raw:: html

  <code data-gist-id="d2bb2eb028b27cf1dace" data-gist-file="03_csv.rb"></code>
  <code data-gist-id="d2bb2eb028b27cf1dace" data-gist-file="03_csv_rb00.png"
        class=code_img ></code>
  <code data-gist-id="d2bb2eb028b27cf1dace" data-gist-file="03_csv_rb01.png"
        class=code_img ></code>
  <code data-gist-id="d2bb2eb028b27cf1dace" data-gist-file="03_csv_rb02.png"
        class=code_img ></code>
  <code data-gist-id="d2bb2eb028b27cf1dace" data-gist-file="03_csv_rb03.png"
        class=code_img ></code>

Awesome! Now we've got our all of our cards prototyped out. Let's add two more calls before we bring this to the table:

  * ``save_pdf`` that stitches our images out to pdf
  * A version number, based on today's date

.. raw:: html

  <code data-gist-id="d2bb2eb028b27cf1dace" data-gist-file="04_save_pdf.rb">
  </code>

The file ``_output/output.pdf`` gets created now. Note that we *don't* want to print out the bleed area, as that is for the printing process, so we add a 1/8-inch trim (Squib defaults to 300ppi, so 300/8=37.5). The ``save_pdf`` defaults to 8.5x11 piece of landscape paper, and arranges the cards in rows - ready for you to print out and play!

If you're working with version control, I recommend committing multiple times throughout this process. At this stage, I recommend creating a tag when you are ready to print something out so you know what version precisely you printed out.

To the table!
-------------

Squib's job is done, for at least this prototype anyway. Now let's print this sheet out and make some cards!

My recommended approach is to get the following:

  * A pack of standard sized sleeves, 2.5"x3.5"
  * Some cardstock to give the cards some spring
  * A paper trimmer, rotary cutter, knife+steel ruler - some way to cut your cards quickly.

Print your cards out on regular office paper. Cut them along the trim lines. Also, cut your cardstock (maybe a tad smaller than 2.5x3.5) and sleeve them. I will often color-code my cardstock backs in prototypes so I can easily tell them apart. Put the cards into the sleeves. You've got your deck!

Now the most important part: play it. When you think of a rule change or card clarification, just pull the paper out of the sleeve and write on the card. These card print-outs are short-lived anyway.

When you playtest, take copious notes. If you want, you can keep those notes in the PLAYTESTING.md file.

Next up...
-----------------------------

We've got a long way to go on our game. We need artwork, iconography, more data, and more cards. We have a lot of directions we could go from here, so in our next guide we'll start looking at a variety of strategies. We'll also look at ways we can keep our code clean and simple so that we're not afraid to change things later on.
