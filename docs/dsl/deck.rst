Squib::Deck.new
===============

The main interface to Squib. Yields to a block that is used for most of Squib's operations. The majority of the :doc:`DSL methods </dsl/index>` are instance methods of ``Squib::Deck``.

Options
-------
These options set immutable properties for the life of the deck. They are not intended to be changed in the middle of Squib's operation.

width
  default: ``825``

  the width of each card in pixels, :doc:`including bleed </bleed>`. Supports :doc:`/units` (e.g. ``'2.5in'``).

height
  default: ``1125``

  the height of each card in pixels, :doc:`including bleed </bleed>`. Supports :doc:`/units` (e.g. '3.5in').

cards
  default: ``1``

  the number of cards in the deck

dpi
  default: ``300``

  the pixels per inch when rendering out to PDF, doing :doc:`/units`, or other operations that require measurement.

config
  default: ``'config.yml'``

  the file used for global settings of this deck, see :doc:`/config`. If the file is not found, Squib does not complain.

  .. note ::

    Since this option has ``config.yml`` as a default, then Squib automatically looks up a ``config.yml`` in the current working directory.

layout
  default: ``nil``

  load a YML file of :doc:`custom layouts </layouts>`. Multiple files in an array are merged sequentially, redefining collisons in the merge process. If no layouts are found relative to the current working directory, then Squib checks for a `built-in layout <https://github.com/andymeneely/squib/tree/master/lib/squib/layouts>`_.

Examples
--------
