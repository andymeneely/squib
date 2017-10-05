yaml
====

Pulls deck data from a YAML files into a ``Squib::DataFrame`` (essentially a hash of arrays).

Parsing uses Ruby's built-in Yaml package.

The ``yaml`` method is a member of ``Squib::Deck``, but it is also available outside of the Deck DSL with ``Squib.yaml()``. This allows a construction like::

  data = Squib.Yaml file: 'data.yml'
    Squib::Deck.new(cards: data['name'].size) do
  end

The Yaml file format assumes that the entire deck is an array, then each element of the array is a hash. Every key encountered in that hash will translate to a "column" in the data frame. If a key exists in one card and not in another, then it defaults to ``nil``.

.. warning::

  Case matters in your Yaml keys.

Options
-------

file
  default: ``'deck.yml'``

  the YAML-formatted file to open. Opens relative to the current directory. If ``data`` is set, this option is overridden.

data
  default: ``nil``

  when set, method will parse this Yaml data instead of reading the file.

explode
  default: ``'qty'``

  Quantity explosion will be applied to the column this name. For example, rows in the csv with a ``'qty'`` of 3 will be duplicated 3 times.


Individual Pre-processing
-------------------------

The ``yaml`` method also takes in a block that will be executed for each cell in your data. This is useful for processing individual cells, like putting a dollar sign in front of dollars, or converting from a float to an integer. The value of the block will be what is assigned to that cell. For example::

  resource_data = Squib.yaml(file: 'sample.yaml') do |header, value|
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
