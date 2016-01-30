xlsx
====

Pulls ExcelX data from .xlsx files into a hash of arrays keyed by the headers. First row is assumed to be the header row.

The ``csv`` method is a member of ``Squib::Deck``, but it is also available outside of the Deck DSL with ``Squib.csv()``. This allows a construction like::

  data = Squib.xlsx file: 'data.xlsx'
  Squib::Deck.new(cards: data['name'].size) do
  end


Options
-------

file
  default: ``'deck.xlsx'``

  the xlsx-formatted file to open. Opens relative to the current directory.

sheet
  default: ``0``

  The zero-based index of the sheet from which to read.

strip
  default: ``true``

  When ``true``, strips leading and trailing whitespace on values and headers

explode
  default: ``'qty'``

  Quantity explosion will be applied to the column this name. For example, rows in the csv with a ``'qty'`` of 3 will be duplicated 3 times.

Examples
--------
