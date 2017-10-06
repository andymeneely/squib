safe_zone
---------

Draw a rounded rectangle set in from the edges of the card to indicate the bleed area.

This method is a wrapper around :doc:`/dsl/rect`, with its own defaults.

Options
^^^^^^^
.. include:: /args/expansion.rst

margin
  default: '0.25in'

  The distance from the edge of the card to the safe zone. Supports :doc:`/units`.

width
  default: ``width - margin`` (the width of the deck minus the margin)

  the width of the box. Supports :doc:`/units`.


height
  default: ``height - margin`` (the height of the deck minus the margin)

  the height of the box. Supports :doc:`/units`.

fill_color
  default: ``'#0000'`` (fully transparent)

  the color or gradient to fill with. See :doc:`/colors`.


stroke_color
  default: ``:blue``

  the color with which to stroke the outside of the shape. See :doc:`/colors`.


stroke_width
  default: ``1.0``

  the width of the outside stroke. Supports :doc:`/units`.


stroke_strategy
  default:  ``:fill_first``

  Specify whether the stroke is done before (thinner) or after (thicker) filling the shape.

  Must be either ``:fill_first`` or ``:stroke_first`` (or their string equivalents).

dash
  default: ``'3 3'`` (no dash pattern set)

  Define a dash pattern for the stroke. This is a special string with space-separated numbers that define the pattern of on-and-off alternating strokes, measured in pixels or units. For example, ``'0.02in 0.02in'`` will be an equal on-and-off dash pattern. Supports :doc:`/units`.

cap
  default: ``:butt``

  Define how the end of the stroke is drawn. Options are ``:square``, ``:butt``, and ``:round`` (or string equivalents of those).

x
  default: ``margin`` (whatever the margin was set to)

  the x-coordinate to place, relative to the upper-left corner of the card and moving right as it increases. Supports :doc:`/units`.

y
  default: ``margin`` (whatever the margin was set to)

  the y-coordinate to place, relative to the upper-left corner of the card and moving downward as it increases. Supports :doc:`/units`.

.. include:: /args/range.rst
.. include:: /args/layout.rst

angle
  default: 0

  the angle at which to rotate the rectangle about it's upper-left corner

Examples
^^^^^^^^

.. literalinclude:: ../../samples/shapes/_proofs.rb
  :linenos:

.. raw:: html

  <img src="../shapes/proof_poker_00_expected.png" width=600 class="figure">

  <img src="../shapes/proof_tiny_00_expected.png" width=600 class="figure">
