Configuration Options
=====================

Squib supports various configuration properties that can be specified in an external file. By default, Squib looks for a file called ``config.yml`` in the current directory. Or, you can set the  ``config:`` option in ``Deck.new`` to specify the name of the configuration file.

These properties are intended to be immutable for the life of the Deck, and intended to configure how Squib behaves.

The options include:

progress_bars
  default: ``false``

  When set to ``true``, long-running operations will show a progress bar in the console

hint
  default: ``:off``

  Text hints are used to show the boundaries of text boxes. Can be enabled/disabled for individual commands, or set globally with the `hint` method. This setting is overridden by `hint` (and subsequently individual :doc:`/dsl/text`).

custom_colors
  default: ``{}``

  Defines globally-available named colors available to the deck. Must be specified as a hash in yaml. For example::

    # config.yml
    custom_colors:
      fg: '#abc'
      bg: '#def'


antialias
  default: ``'best'``

  Set the algorithm that Cairo will use for anti-aliasing throughout its rendering. Available options are ``fast``, ``good``, ``best``, ``none``, ``gray``, ``subpixel``.

  Not every option is available on every platform. Using our benchmarks on large decks, `best` is only ~10% slower anyway. For more info see the `Cairo docs <http://www.cairographics.org/manual/cairo-cairo-t.html#cairo-antialias-t>`_.

backend
  default: ``'memory'``

  Defines how Cairo will store the operations. Can be ``svg`` or ``memory``. See :doc:`/backends`.

prefix
  default: ``'card_'``

  When using an SVG backend, cards are auto-saved with this prefix and ``'%02d'`` numbering format.

warn_ellipsize
  default: true

  Show a warning on the console when text is ellipsized. Warning is issued per card.

warn_png_scale
  default: true

  Show a warning on the console when a PNG file is upscaled. Warning is issued per card.

Options are available as methods
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

For debugging/sanity purposes, if you want to make sure your configuration options are parsed correctly, the above options are also available as methods within ``Squib::Deck``, for example::

  Squib::Deck.new do
    puts backend # prints 'memory' by default
  end
