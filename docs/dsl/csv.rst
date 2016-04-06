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


Examples
--------
