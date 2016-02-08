save
====

Saves the given range of cards to either PNG or PDF. Wrapper method for other save methods.

Options
-------

This method delegates everything to :doc:`save_png` or :doc:`save_pdf` using the ``format`` option. All other options are passed along.

format
  default: ``[]`` (do nothing)

  Use ``:png`` to save as a PNG, and ``:pdf`` to save as PDF. To save to both at once, use ``[:png, :pdf]``

Examples
--------

::

  save format: :png, prefix: 'front_' # same as: save_png prefix: 'front_'
  save format: :pdf, prefix: 'cards_' # same as: save_pdf prefix: 'cards_'
  save format: [:png, :pdf]           # same as: save_png; save_pdf
