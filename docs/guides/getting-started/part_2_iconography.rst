The Squib Way pt 2: Iconography
===================================

.. warning::

  This chapter is still being written

In the previous guide, we walked you through the basics of going from ideas in your head to a very simple set of cards ready for playtesting at the table. In this guide we take the next step: creating a visual language.

Art: Graphic Design vs. Illustration
------------------------------------

A common piece of advice in the prototyping world is "Don't worry about artwork, just focus on the game and do the artwork later". That's good advice, but a bit over-simplified. What folks usually mean by "artwork" is really "illustration", like the oil painting of a wizard sitting in the middle of the card or the intricate border around the edges.

But games are more than just artwork with text - they're a system of rules that need to be efficiently conveyed to the players. They're a *visual language*. When players are new to your game, the layout of the cards need to facilitate learning. When players are competing in their 30th game, though, they need the cards to maximize usability by reducing their memory load, moving gameplay along efficiently, and provide an overall aesthetic that conveys the game theme. That's what graphic design is all about, and requires a game designer's attention much more than commissioning an illustration.

Developing the visual language on your cards is not a trivial task. It's one that takes a lot of iteration, feedback, testing, improvement, failure, small successes, and reverse-engineering. It's something you should consider in your prototype early on. It's also a series of decisions that don't necessarily require artistic ability - just an intentional effort applied to usability.

Icons and the their placement are, perhaps, the most efficient and powerful tools in your toolbelt for conveying your game's world. In the prototyping process, you don't need to be worried about using icons that are your *final* icons, but you should put some thought into what the visuals will look like because you'll be iterating on that in the design process.

Iconography in Popular Games
----------------------------

When you get a chance, I highly recommend studying the iconography of some popular games. What works for you? What didn't? What kinds of choices did the designers make that works *for their game*? Here are a few that come my mind:

Race for the Galaxy
^^^^^^^^^^^^^^^^^^^

The majority of the cards in RFTG have no description text on them, and yet the game contains hundreds of unique cards. RFTG has a vast, rich visual iconography that conveys a all of the bonuses and trade-offs of a card efficiently to the user. As a drawback, though, the visual language can be intimidating to new players - every little symbol and icon means a new thing, and sometimes you just need to memorize that "this card does that", until you realize that the icons show that.

But once you know the structure of the game and what various bonuses mean, you can understand new cards very easily. Icons are combined in creative ways to show new bonuses. Text is used only when a bonus is much more complicated than what can be expressed with icons. Icons are primarily arranged along left side of the card so you can hold them in your hand and compare bonuses across cards quickly. All of these design decisions match the gameplay nicely because the game consists of a lot of scrolling through cards in your hand and evaluating which ones you want to play.

Go check out images of Race for the Galaxy `on BoardGameGeek.com <https://boardgamegeek.com/boardgame/28143/race-galaxy>`_.

Dominion
^^^^^^^^

Unlike RFTG, Dominion has a much simpler iconography. Most of the bonuses are conveyed in a paragraph of text in the description, with a few classifications conveyed by color or format. The text has icons embedded in it to tie in the concept of Gold, Curses, or Victory Points.

But Dominion's gameplay is much different: instead of going through tons of different cards, you're only playing with 10 piles of cards in front of you. So each game really just requires you to remember what 10 cards mean. Once you purchase a card and it goes into your deck, you don't need to evaluate its worth quickly as in RFTG because you already bought it. Having most of the game's bonuses in prose means that new bonuses are extremely flexible in their expression. As a result, Dominion's bonuses and iconography is much more about text and identifying known cards than about evaluating new ones.

Go check out images of Dominion `on BoardGameGeek.com <https://boardgamegeek.com/boardgame/36218/dominion>`_

How Squib Supports Iconography
------------------------------

Squib is good for supporting any kind of layout you can think of, but it's also good for supporting multiple ways of translating your data into icons on cards. Here are some ways that Squib provides support for your ever-evolving iconography:

  * :doc:`/dsl/svg` method, and all of its features like scaling, ID-specific rendering, direct XML manipulation, and all that the SVG file format has to offer
  * :doc:`/dsl/png` method, and all of its features like blending operators, alpha transparency, and masking
  * Layout files allow multiple icons for one data column (see :doc:`/layouts`)
  * Layout files also have the ``extends`` feature that allows icons to inherit details from each other
  * The ``range`` option on :doc:`/dsl/text`, :doc:`/dsl/svg`, and :doc:`/dsl/png` allows you to specify text and icons for any subset of your files
  * The :doc:`/dsl/text` method allows for embedded icons.
  * Ruby provides neat ways of aggregating data with ``inject``, ``map``, and ``zip`` that supports iconography

Back to the Example: Drones vs. Humans
--------------------------------------

Ok, let's go back to our running example, project ``arctic-lemming`` from Part 1. We created cards for playtesting, but we never put down the faction for each card. That's a good candidate for an icon.

Let's get some stock icons for this exercise. For this example, I went to http://game-icons.net. I set my foreground color to black, and background to white. I then  downloaded "auto-repair.svg" and "backup.svg". I'm choosing not to rename the files so that I can find them again on the website if I need to. (If you want to know how to do this process DIRECTLY from Ruby, and not going to the website, check out my *other* Ruby gem called `game_icons <https://github.com/andymeneely/game_icons>`_ - it's tailor-made for Squib!)

When we were brainstorming our game, we placed one category of icons in a single column ("faction"). Presumably, one would want the faction icon to be in the same place on every card, but a different icon depending on the card's faction. There are a couple of ways of accomplishing this in Squib. First, here some less-than-clean ways of doing it::

  svg range: 0, file: 'auto_repair.svg' # hard-coded range number? not flexible
  svg range: 1, file: 'auto_repair.svg' # hard-coded range number? not flexible
  svg range: 2, file: 'backup.svg'      # hard-coded range number? not flexible
  svg range: 3, file: 'backup.svg'      # hard-coded range number? not flexible
  # This gets very hard to maintain over time
  svg file: ['auto_repair.svg', 'auto_repair.svg', 'backup.svg', 'backup.svg']
  # This is slightly easier to maintain, but is more verbose and still hardcoded
  svg range: 0..1, file 'auto_repair.svg'
  svg range: 2..3, file 'backup.svg'

That's too much hardcoding of data into our Ruby code. That's what layouts are for. Now, we've already specified a layout file in our prior example. Fortunately, Squib supports *multiple* layout files, which get combined into a single set of layout styles. So let's do that: we create our own layout file that defines what a ``human`` is and what a ``drone`` is. Then just tell ``svg`` to use the layout data. The data column is simply an array of factions, the icon call is just connecting the factions to their styles with::

  svg layout: data['faction']

So, putting it all together, our code looks like this.

.. raw:: html

  <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
  <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/gist-embed/2.4/gist-embed.min.js"></script>
  <code data-gist-id="d2bb2eb028b27cf1dace"
        data-gist-file="_part2_01_factions.rb"
        data-gist-highlight-line="13"
        ></code>
  <code data-gist-id="d2bb2eb028b27cf1dace"
        data-gist-file="_part2_01_factions.yml"></code>
  <code data-gist-id="d2bb2eb028b27cf1dace" data-gist-file="data.csv"></code>
  <code data-gist-id="d2bb2eb028b27cf1dace"
        data-gist-file="_part2_01_factions_00.png"></code>

**BUT!** There's a very important software design principle we're violating here. It's called DRY: Don't Repeat Yourself. In making the above layout file, I hit copy and paste. What happens later when we change our mind and want to move the faction icon!?!? We have to change TWO numbers. Blech.

There's a better way: ``extends``

The layout files in Squib also support a special keyword, ``extends``, that allows us to "copy" (or "inherit") another style onto our own, and then we can override as we see fit. Thus, the following layout is a bit more DRY:

.. raw:: html

  <code data-gist-id="d2bb2eb028b27cf1dace"
      data-gist-file="_part2_02_factions.yml"></code>

Much better!

Now if we want to add a new faction, we don't have to copy-pasta any code! We just extend from faction and call in our new SVG file. Suppose we add a new faction that needs a bigger icon - we can define our own ``width`` and ``height`` beneath the ``extends`` that will override the parent values of 75.

Looks great! Now let's get these cards out to the playtesting table!

At this point, we've got a very scalable design for our future iterations. Let's take side-trip and discuss why this design works.

Why Ruby+YAML+Spreadsheets Works
--------------------------------

In software design, a "good" design is one where the problem is broken down into a set of easier duties that each make sense on their own, where the interaction between duties is easy, and where to place new responsbilities is obvious.

In Squib, we're using automation to assist the prototyping process. This means that we're going to have a bunch of decisions and responsibilities, such as:

  * *Game data decisions*. How many of this card should be in the deck? What should this card be called? What should the cost of this card be?
  * *Style Decisions*. Where should this icon be? How big should the font be? What color should we use?
  * *Logic Decisions*. Can we build this to a PDF, too? How do we save this in black-and-white? Can we include a time stamp on each card? Can we just save one card this time so we can test quickly?

With the Ruby+YAML+Spreadsheets design, we've separated these three kinds of questions into three areas:

  * Game data is in a spreadsheet
  * Styles are in YAML layout files
  * Code is in Ruby

When you work with this design, you'll probably find yourself spending a lot of time working on one of these files for a long time. That means this design is working.

For example, you might be adjusting the exact location of an image by editing your layout file and re-running your code over and over again to make sure you get the exact x-y coordinates right. That's fine. You're not making game data decisions in that moment, so you shouldn't be presented with any of that stuff. This eases the cognitive complexity of what you're doing.

The best way to preserve this design is to try to keep the Ruby code clean. As wonderful as Ruby is, it's the hardest of the three to edit. It is code, after all. So don't clutter it up with game data or style data - let it be the glue between your styles and your game.

Ok, let's get back to this prototype.

Icons for Some, But Not All, Cards
----------------------------------

.. note::

  to be written

One Column per Icon
-------------------

.. note::

  to be written
