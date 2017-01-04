Squib::DataFrame
================

As described in :doc:`/data`, the ``Squib::DataFrame`` is what is returned by Squib's data import methods (:doc:`/dsl/csv` and :doc:`/dsl/xlsx`).

It behaves like a ``Hash`` of ``Arrays``, so acessing an individual column can be done via the square brackets, e.g. ``data['title']``.

Here are some other convenience methods in ``Squib::DataFrame``

columns become methods
----------------------

Through magic of Ruby metaprogramming, every column also becomes a method on the data frame. So these two are equivalent:

.. code-block:: irb

  irb(main):002:0> data = Squib.csv file: 'basic.csv'
  => #<Squib::DataFrame:0x00000003764550 @hash={"h1"=>[1, 3], "h2"=>[2, 4]}>
  irb(main):003:0> data.h1
  => [1, 3]
  irb(main):004:0> data['h1']
  => [1, 3]

#columns
--------

Returns an array of the column names in the data frame

#ncolumns
---------

Returns the number of columns in the data frame

#col?(name)
-----------

Returns ``true`` if there is column ``name``.

#row(i)
-------

Returns a hash of values across all columns in the i-th row of the dataframe. Represents a single card.

#nrows
------

Returns the number of rows the data frame has, computed by the maximum length of any column array.

#to_json
--------

Returns a ``json`` representation of the entire data frame.

#to_pretty_json
---------------

Returns a ``json`` representation of the entire data frame, formatted with indentation for human viewing.

#to_pretty_text
---------------

Returns a textual representation of the dataframe that emulates what the information looks like on an individual card. Here's an example:

.. code-block:: text

              ╭------------------------------------╮
         Name | Mage                               |
         Cost | 1                                  |
  Description | You may cast 1 spell per turn      |
        Snark | Magic, dude.                       |
              ╰------------------------------------╯
              ╭------------------------------------╮
         Name | Rogue                              |
         Cost | 2                                  |
  Description | You always take the first turn.    |
        Snark | I like to be sneaky                |
              ╰------------------------------------╯
              ╭------------------------------------╮
         Name | Warrior                            |
         Cost | 3                                  |
  Description |
        Snark | I have a long story to tell to tes |
              | t the word-wrapping ability of pre |
              | tty text formatting.               |
              ╰------------------------------------╯
