png
===

Renders PNG images.

Options
-------
.. include:: /args/expansion.rst

file
  default: ``''`` (empty string)

  file(s) to read in. As in :doc:`/arrays`, if this a single file, then it's use for every card in range. If the parameter is an Array of files, then each file is looked up for each card. If any of them are nil or '', nothing is done for that card.

.. include:: /args/xy.rst

width
  default: ``:native``

  the pixel width that the image should scale to. Supports :doc:`/units`. When set to ``:native``, uses the DPI and units of the loaded SVG document. Using ``:deck`` will scale to the deck width. Using ``:scale`` will use the ``height`` to scale and keep native the aspect ratio. Scaling PNGs is not recommended for professional-looking cards, and up-scaling a PNG will throw a warning in the console (see :doc:`/config`). Supports :doc:`/units` and :doc:`/shorthands`.

height
  default: ``:native``

  the pixel height that the image should scale to. Supports :doc:`/units`. When set to ``:native``, uses the DPI and units of the loaded SVG document. Using ``:deck`` will scale to the deck height. Using ``:scale`` will use the ``width`` to scale and keep native the aspect ratio. Scaling PNGs is not recommended for professional-looking cards, and up-scaling a PNG will throw a warning in the console (see :doc:`/config`). Supports :doc:`/units` and :doc:`/shorthands`.

alpha
  default: 1.0

  the alpha-transparency percentage used to blend this image. Must be between ``0.0`` and ``1.0``

blend
  default: ``:none``

  the composite blend operator used when applying this image. See Blend Modes at http://cairographics.org/operators.
  The possibilties include: :none, :multiply, :screen, :overlay, :darken, :lighten, :color_dodge, :color_burn, :hard_light, :soft_light, :difference, :exclusion, :hsl_hue, :hsl_saturation, :hsl_color, :hsl_luminosity. String versions of these options are accepted too.

mask
  default: ``nil``

  Accepts a color (see :doc:`/colors`). If specified, the image will be used as a mask for the given color/gradient. Transparent pixels are ignored, opaque pixels are the given color. Note: the origin for gradient coordinates is at the given x,y, not at 0,0 as it is most other places.

placeholder
  default: ``nil``

  if ``file`` does not exist, but the file pointed to by this string does, then draw this image instead.

  No warning is thrown when a placeholder is used.

  If this is non-nil, but the placeholder file does not exist, then a warning is thrown and no image is drawn.

  Examples of how to use placeholders are below.

.. include:: /args/transform.rst

.. include:: /args/range.rst
.. include:: /args/layout.rst

Examples
--------

These examples live here: https://github.com/andymeneely/squib/tree/dev/samples/images

.. literalinclude:: ../../samples/images/_images.rb
  :linenos:

.. raw:: html

  <img src="../images/_images_00_expected.png" width=600 class="figure">

.. literalinclude:: ../../samples/images/_placeholders.rb
  :linenos:

First placeholder expected output.

.. raw:: html

  <img src="../images/placeholder_sheet_00_expected.png" width=100 class="figure">

Second placeholder expected output.

.. raw:: html

  <img src="../images/multi_placeholder_sheet_00_expected.png" width=100 class="figure">