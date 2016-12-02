Be Data-Driven with XLSX and CSV
================================

Squib supports importing data from ExcelX (.xlsx) files and Comma-Separated Values (.csv) files. Because :doc:`/arrays`, these methods are column-based, which means that they assume you have a header row in your table, and that header row will define the name of the column.

Squib::DataFrame, or a Hash of Arrays
-------------------------------------

In both DSL methods, Squib will return a "data frame" (literally of type ``Squib::DataFrame``). The best way to think of this is a ``Hash`` of ``Arrays``, where each column is a key in the hash, and every element of each Array represents a data point on a card.

The data import methods expect you to structure your Excel sheet or CSV like this:

  * First row should be a header - preferably with concise naming since you'll reference it in Ruby code
  * Rows should represent cards in the deck
  * Columns represent data about cards (e.g. "Type", "Cost", or "Name")

Of course, you can always import your game data other ways using just Ruby (e.g. from a REST API, a JSON file, or your own custom format). There's nothing special about Squib's methods in how they relate to ``Squib::Deck`` other than their convenience.

See :doc:`/dsl/xlsx` and :doc:`/dsl/csv` for more details and examples on how the data can be imported.

The ``Squib::DataFrame`` class provides much more than what a ``Hash`` provides, however. The :doc:`/dsl/data_frame`

Quantity Explosion
------------------

If you want more than one copy of a card, then have a column in your data file called ``Qty`` and fill it with counts for each card. Squib's :doc:`/dsl/xlsx` and :doc:`/dsl/xlsx` methods will automatically expand those rows according to those counts. You can also customize that "Qty" to anything you like by setting the `explode` option (e.g. ``explode: 'Quantity'``). Again, see the specific methods for examples.
