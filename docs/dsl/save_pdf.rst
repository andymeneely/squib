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

Examples
--------
