save_pdf
========

Lays out the cards in a gride and renders a PDF.

Options
-------

file
  default: ``'output.pdf'``

  the name of the PDF file to save. Will be overwritten without warning.

dir
  default: ``_output``

  the directory to save to. Created if it doesn't exist.

sprue
  default: ``nil``

  the sprue file to use. If ``nil``, then no sprue is used and the cards are laid out automatically using the parameters below. If non-nil, Squib checks for a built-in sprue file of that name. Otherwise, it attempts to open a file relative to the current directory. For more information on Squib Sprues, see :doc:`/sprues`.

width
  default: ``3300``

  the height of the page in pixels. Default is 11in * 300dpi. Supports :doc:`/units`.

height
  default: ``2550``

  the height of the page in pixels. Default is 8.5in * 300dpi. Supports :doc:`/units`.

margin
  default: ``75``

  the margin around the outside of the page. Supports :doc:`/units`.

gap
  default: ``0``

  the space in pixels between the cards. Supports :doc:`/units`.

trim
  default: ``0``

  the space around the edge of each card to trim (e.g. to cut off the bleed margin for print-and-play). Supports :doc:`/units`.

crop_marks
  default: ``false``

  When ``true``, draws lines in the margins as guides for cutting. Crop marks factor in the ``trim`` (if non-zero), and can also be customized via ``crop_margin_*`` options (see below). Has no effect if ``margin`` is 0.

.. warning::

  Enabling this feature will draw lines to the edge of the page. Most PDF Readers, by default, will recognize this and scale down the entire PDF to fit in those crop marks - throwing off your overall scale. To disable this, you will need to set Print Scaling "Use original" or "None" when you go to print (this looks different for different PDF readers). Be sure to test this out before you do your big print job!!

crop_margin_bottom
  default: 0

  The space between the bottom edge of the (potentially trimmed) card, and the crop mark. Supports :doc:`/units`. Has no effect if ``crop_marks`` is ``false``.

crop_margin_left
  default: 0

  The space between the left edge of the (potentially trimmed) card, and the crop mark. Supports :doc:`/units`. Has no effect if ``crop_marks`` is ``false``.

crop_margin_right
  default: ``0``

  The space between the right edge of the (potentially trimmed) card, and the crop mark. Supports :doc:`/units`. Has no effect if ``crop_marks`` is ``false``.

crop_margin_top
  default: ``0``

  The space between the top edge of the (potentially trimmed) card, and the crop mark. Supports :doc:`/units`. Has no effect if ``crop_marks`` is ``false``.

crop_stroke_color
  default: ``:black``

  The color of the crop mark lines. Has no effect if ``crop_marks`` is ``false``.

crop_stroke_dash
  default: ``''``

  Define a dash pattern for the crop marks. This is a special string with space-separated numbers that define the pattern of on-and-off alternating strokes, measured in pixels or units. For example, ``'0.02in 0.02in'`` will be an equal on-and-off dash pattern. Supports :doc:`/units`. Has no effect if ``crop_marks`` is ``false``.

crop_stroke_width
  default: ``1.5``

  Width of the crop mark lines. Has no effect if ``crop_marks`` is ``false``.

rtl
  default ``false``

    whether to render columns right to left, used for duplex printing of card backs

Examples
--------
