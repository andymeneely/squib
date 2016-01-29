fill_color
  default: ``'#0000'`` (fully transparent)

  the color or gradient to fill with. See :doc:`/colors`.


stroke_color
  default: ``:black``

  the color with which to stroke the outside of the rectangle. See :docs:`/colors`.


stroke_width
  default: ``2``

  the width of the outside stroke. Supports :doc:`/units`.


stroke_strategy
  default:  ``:fill_first``

  Specify whether the stroke is done before (thinner) or after (thicker) filling the shape.

  Must be either ``:fill_first`` or ``:stroke_first`` (or their string equivalents).

dash
  default: ``''`` (no dash pattern set)

  Define a dash pattern for the stroke. This is a special string with space-separated numbers that define the pattern of on-and-off alternating strokes, measured in pixels or units. For example, ``'0.02in 0.02in'`` will be an equal on-and-off dash pattern. Supports :doc:`/units`.

cap
  default: ``:butt``

  Define how the end of the stroke is drawn. Options are ``:square``, ``:butt``, and ``:round`` (or string equivalents of those).
