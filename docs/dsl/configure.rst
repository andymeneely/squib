Squib.configure
---------------

Prior to the construction of a Squib::Deck, set a global default that overrides what is specified `config.yml`.

This is intended to be done prior to Squib::Deck.new, and is intended to be used inside of a Rakefile

Options
^^^^^^^

All options that are specified in :doc:`/config`

Exmaples
^^^^^^^^

.. literalinclude:: ../../samples/project/Rakefile
  :language: ruby
  :linenos:
