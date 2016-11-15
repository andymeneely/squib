xlsx
====

Pulls ExcelX data from .xlsx files into a hash of arrays keyed by the headers. First row is assumed to be the header row.

The ``xlsx`` method is a member of ``Squib::Deck``, but it is also available outside of the Deck DSL with ``Squib.xlsx()``. This allows a construction like::

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

Individual Pre-processing
-------------------------

The ``xlsx`` method also takes in a block that will be executed for each cell in your data. This is useful for processing individual cells, like putting a dollar sign in front of dollars, or converting from a float to an integer. The value of the block will be what is assigned to that cell. For example::

  resource_data = Squib.xlsx(file: 'sample.xlsx') do |header, value|
    case header
    when 'Cost'
      "$#{value}k" # e.g. "3" becomes "$3k"
    else
      value # always return the original value if you didn't do anything to it
    end
  end

Examples
--------

To get the sample Excel files, go to `its source <https://github.com/andymeneely/squib/tree/dev/samples/data>`_

.. literalinclude:: ../../samples/data/_excel.rb
  :language: ruby
  :linenos:
