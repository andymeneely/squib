save_pdf
========

Lays out the cards in range on a sheet and renders a PDF

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


Examples
--------
