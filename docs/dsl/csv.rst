csv
===

Pulls CSV data from .csv files into a hash of arrays keyed by the headers. First row is assumed to be the header row.

Parsing uses Ruby's CSV, with options ``{headers: true, converters: :numeric}``
http://www.ruby-doc.org/stdlib-2.0/libdoc/csv/rdoc/CSV.html

The ``csv`` method is a member of ``Squib::Deck``, but it is also available outside of the Deck DSL with ``Squib.csv()``. This allows a construction like::

  data = Squib.csv file: 'data.csv'
  Squib::Deck.new(cards: data['name'].size) do
  end


Options
-------

file
  default: ``'deck.csv'``

  the CSV-formatted file to open. Opens relative to the current directory. If ``data`` is set, this option is overridden.

data
  default: ``nil``

  when set, CSV will parse this data instead of reading the file.

strip
  default: ``true``

  When ``true``, strips leading and trailing whitespace on values and headers

explode
  default: ``'qty'``

  Quantity explosion will be applied to the column this name. For example, rows in the csv with a ``'qty'`` of 3 will be duplicated 3 times.

col_sep
  default: ``','``

  Column separator. One of the CSV custom options in Ruby. See next option below.

CSV custom options in Ruby standard lib.
  All of the options in Ruby's std lib version of CSV are supported **except** ``headers`` is always ``true`` and ``converters`` is always set to ``:numeric``. See the `Ruby Docs <http://ruby-doc.org/stdlib-2.2.0/libdoc/csv/rdoc/CSV.html#method-c-new>`_ for information on the options.

Individual Pre-processing
-------------------------

The ``xlsx`` method also takes in a block that will be executed for each cell in your data. This is useful for processing individual cells, like putting a dollar sign in front of dollars, or converting from a float to an integer. The value of the block will be what is assigned to that cell. For example::

  resource_data = Squib.csv(file: 'sample.xlsx') do |header, value|
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

.. literalinclude:: ../../samples/data/_csv.rb
  :language: ruby
  :linenos:

Here's the sample.csv

.. literalinclude:: ../../samples/data/sample.csv
  :language: text
  :linenos:

Here's the quantity_explosion.csv

.. literalinclude:: ../../samples/data/quantity_explosion.csv
  :language: text
  :linenos:
