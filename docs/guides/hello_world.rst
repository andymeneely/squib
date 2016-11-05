Hello, World! Dissected
=======================

After seeing Squib's `landing page <http://squib.rocks>`_, your might find it helpful to dissect what's really going on in each line of code of a basic Squib snippet.

.. code-block:: ruby
   :linenos:

   require 'squib'

   Squib::Deck.new width: 825, height: 1125, cards: 2 do
     background color: 'pink'
     rect
     text str: ['Hello', 'World!']
     save_png prefix: 'hello_'
   end

Let’s dissect this:

* Line 1: this code will bring in the Squib library for us to use. Keep this at the top.
* Line 2: By convention, we put a blank line between our require statements and the rest of our code
* Line 3: Define a new deck of cards. Just 2 cards. 825 pixels wide etc. Squib also supports :doc:`/units` if you prefer to specify something like ``'2.75in'``.
* Line 4: Set the background to pink. Colors can be in various notations, and supports linear and radial graidents - see :doc:`/colors`.
* Line 5: Draw a rectangle around the edge of each card. Note that this has no arguments, because :doc:`/parameters`. The defaults can be found in the DSL reference for the :doc:`/dsl/rect` method.
* Line 6: Put some text in upper-left the corner of the card, using the default font, etc. See the :doc:`/dsl/text` DSL method for more options. The first card will have ``'Hello'`` and the second card will have ``'World'`` because :doc:`/arrays`.
* Line 7: Save our card out to a png files called ``hello_00.png`` and ``hello_01.png`` saved in the ``_output`` folder.

Dissection of "Even Bigger..."
------------------------------

On Squib's `landing page <http://squib.rocks>`_ we end with a pretty complex example. It's compact and designed to show how much you can get done with a little bit of code. Here's a dissection of that.

.. code-block:: ruby
   :linenos:

   require 'squib'

   Squib::Deck.new(cards: 4, layout: %w(hand.yml even-bigger.yml)) do
     background color: '#230602'
     deck = xlsx file: 'even-bigger.xlsx'
     svg file: deck['Art'], layout: 'Art'

     %w(Title Description Snark).each do |key|
       text str: deck[key], layout: key
     end

     %w(Attack Defend Health).each do |key|
       svg file: "#{key.downcase}.svg", layout: "#{key}Icon"
       text str: deck[key], layout: key
     end

     save_png prefix: 'even_bigger_'
     showcase file: 'showcase.png', fill_color: '#0000'
     hand file: 'hand.png', trim: 37.5, trim_radius: 25, fill_color: '#0000'
   end

* Line 3: Make 4 cards. Use two layouts: the built-in hand.yml (see :doc:`/layouts`) and then our own layout. The layouts get merged, with our own `even-bigger.yml` overriding ``hand.yml`` whenever they collide.
* Line 5: Read some data from an Excel file, which amounts to a column-based hash of arrays, so that each element of an array corresponds to a specific data point to a given card. For example, ``3`` in the ``'Attack'`` column will be put on the second card.
* Line 6: Using the Excel data cell for the filename, we can customize a different icon for every card. But, every SVG in this command will be styled according to the ``Art`` entry in our layout (i.e. in ``even-bigger.yml``)
* Line 8: Iterate over an array of strings, namely, ``'Title'``, ``'Description'``, and ``'Snark'``.
* Line 9: Draw text for the (Title, Description, or Snark), using *their* styling rules in our layout.
* Line 13: Using `Ruby String interpolation <https://en.wikibooks.org/wiki/Ruby_Programming/Syntax/Literals#Interpolation>`_, lookup the appropriate icon (e.g. ``'attack.svg'``), converted to lowercase letters, and then using the Icon layout of that for styling (e.g. ``'AttackIcon'`` or ``'DefendIcon'``)
* Line 17: Render every card to individual PNG files
* Line 18: Render a "showcase" of cards, using a perspective-reflect effect. See :doc:`/dsl/showcase` method.
* Line 19: Render a "hand" of cards (spread over a circle). See :doc:`/dsl/hand` method.
