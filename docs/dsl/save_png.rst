save_png
========

Saves the given range of cards to a PNG

Options
-------

dir
  default: ``'_output'``

  the directory for the output to be sent to. Will be created if it doesn't exist.

prefix
  default ``'card_'``

  the prefix of all the filenames saved

count_format
  default: ``'%02d'``

  the format string used for formatting the card count (e.g. padding zeros). Uses a Ruby format string (see the Ruby doc for ``Kernel::sprintf`` for specifics)

suffix
  default: ``''``

  the suffix of all the filenames saved, just before the `.png` extension.

rotate
  default: ``false``

  If ``true``, the saved cards will be rotated 90 degrees clockwise. Or, rotate by the number of radians. Intended to rendering landscape instead of portrait. Possible values: ``true``, ``false``, ``:clockwise``, ``:counterclockwise``

trim
  default: ``0``

  the space around the edge of each card to trim (e.g. to cut off the bleed margin for print-and-play). Supports :doc:`/units`.

trim_radius
  default: ``0``

  the rounded rectangle radius around the card to trim before saving.

.. include:: /args/range.rst

Examples
--------
