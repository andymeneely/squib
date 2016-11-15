Squib Thinks in Arrays
======================

When prototyping card games, you usually want some things (e.g. icons, text) to remain the same across every card, but then other things need to change per card. Maybe you want the same background for every card, but a different title.

The vast majority of Squib's DSL methods can accept two kinds of input: whatever it's expecting, or an array of whatever it's expecting. If it's an array, then Squib expects each element of the array to correspond to a different card.

Think of this like "singleton expansion", where Squib goes "Is this an array? No? Then just repeat it the same across every card". Thus, these two DSL calls are logically equivalent::

  Squib::Deck.new(cards: 2) do
    text str: 'Hello'
    text str: ['Hello', 'Hello'] # same effect
  end

But then to use a different string on each card you can do::

  Squib::Deck.new(cards: 2) do
    text str: ['Hello', 'World']
  end

.. note::

  Technically, Squib is only looking for something that responds to ``each`` (i.e. an Enumerable). So whatever you give it should just respond to ``each`` and it will work as expected.

What if you have an array that doesn't match the size of the deck? No problem - Ruby won't complain about indexing an array out of bounds - it simply returns ``nil``. So these are equivalent::

  Squib::Deck.new(cards: 3) do
    text str: ['Hello', 'Hello']
    text str: ['Hello', 'Hello', nil]  # same effect
  end

In the case of the :doc:`/dsl/text` method, giving it an ``str: nil`` will mean the method won't do anything for that card and move on. Different methods react differently to getting ``nil`` as an option, however, so watch out for that.


.. _using_ranges:

Using ``range`` to specify cards
--------------------------------

There's another way to limit a DSL method to certain cards: the ``range`` parameter.

Most of Squib's DSL methods allow a ``range`` to be specified. This can be an actual Ruby ``Range``, or anything that implements ``each`` (i.e. an Enumerable) that corresponds to the **index** of each card.

Integers are also supported for changing one card only. Negatives work from the back of the deck.

Some quick examples::

  text range: 0..2  # only cards 0, 1, and 2
  text range: [0,2] # only cards 0 and 2
  text range: 0     # only card 0

Behold! The Power of Ruby Arrays
--------------------------------

One of the more distinctive benefits of Ruby is in its rich set of features for manipulating and accessing arrays. Between ``range`` and using arrays, you can specify subsets of cards quite succinctly. The following methods in Ruby are particularly helpful:

  * `Array#each <http://ruby-doc.org/core-2.2.0/Array.html#method-i-each>`_ - do something on each element of the array (Ruby folks seldom use for-loops!)
  * `Array#map <http://ruby-doc.org/core-2.2.0/Array.html#method-i-map>`_ - do something on each element of an array and put it into a new array
  * `Array#select <http://ruby-doc.org/core-2.2.0/Array.html#method-i-select>`_ - select a subset of an array
  * `Enumerable#each_with_index <http://ruby-doc.org/core-2.2.0/Enumerable.html#method-i-each_with_index>`_ - do something to each element, also being aware of the index
  * `Enumerable#inject <http://ruby-doc.org/core-2.2.0/Enumerable.html#method-i-inject>`_ - accumulate elements of an array in a custom way
  * `Array#zip <http://ruby-doc.org/core-2.2.0/Enumerable.html#method-i-zip>`_ - combine two arrays, element by element

Examples
--------

Here are a few recipes for using arrays and ranges in practice:

.. literalinclude:: ../samples/ranges/_ranges.rb
  :language: ruby
  :linenos:

.. raw:: html

  <img src="ranges/ranges_00_expected.png">

Contribute Recipes!
-------------------

There are a lot more great recipes we could come up with. Feel free to contribute! You can add them here via pull request or `via the wiki <https://github.com/andymeneely/squib/wiki>`_
