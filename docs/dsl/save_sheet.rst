save_sheet
==========

Lays out the cards in range and renders a stitched PNG sheet

Options
-------

range
  default: ``:all``

  the range of cards over which this will be rendered. See {file:README.md#Specifying_Ranges Specifying Ranges}

sprue
  default: ``nil``

  the sprue file to use. If ``nil``, then no sprue is used and the cards are laid out automatically using the parameters below. If non-nil, Squib checks for a built-in sprue file of that name. Otherwise, it attempts to open a file relative to the current directory. For more information on Squib Sprues, see :doc:`/sprues`.

columns
  default: ``5``

  the number of columns in the grid. Must be an integer

rows
  default: ``:infinite``

  the number of rows in the grid. When set to :infinite, the sheet scales to the rows needed. If there are more cards than rows*columns, new sheets are started.

prefix
  default: ``card_``

  the prefix of the file name(s)

count_format
  default: ``'%02d'``

  the format string used for formatting the card count (e.g. padding zeros). Uses a Ruby format string (see the Ruby doc for ``Kernel::sprintf`` for specifics)

dir
  default: ``'_output'``

  the directory to save to. Created if it doesn't exist.

margin
  default: ``0``

  the margin around the outside of the sheet. Supports :doc:`/units`.

gap
  default ``0``

  the space in pixels between the cards. Supports :doc:`/units`.

trim
  default ``0``

  the space around the edge of each card to trim (e.g. to cut off the bleed margin for print-and-play). Supports :doc:`/units`. Must be the same for all cards.

trim_radius
  default: ``0``

  the rounded rectangle radius around the card to trim before saving. Supports :doc:`/units`. Must be the same for all cards.

rtl
  default ``false``

  whether to render columns right to left, used for duplex printing of card backs

Examples
--------
