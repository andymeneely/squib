Squib Thinks in Arrays
======================


.. _using_ranges:

Using ``range`` to specify cards
--------------------------------

There's another way to limit a method to certain cards: the ``range`` parameter.

Most of Squib's DSL methods allow a `range` to be specified as a first parameter. This parameter is used to access an internal `Array` of `Squib::Cards`. This can be an actual Ruby range, or anything that implements `#each` (thus can be an `Enumerable`). Integers are also supported for changing one card only. Negatives work from the back of the deck.

Here are some examples from `samples/ranges.rb` found [here](https://github.com/andymeneely/squib/tree/master/samples/ranges.rb)
