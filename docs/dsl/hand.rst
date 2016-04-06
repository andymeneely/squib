hand
====

Renders a range of cards fanned out as if in a hand. Saves as PNG regardless of back end.

Options
-------

radius
  default: ``:auto``

  The distance from the bottom of each card to the center of the fan. If set to ``:auto``, then it is computed as 30% of the card's height. Why 30%? Because it looks good that way. Reasons.

angle_range
  default: ``((Math::PI / -4.0)..(Math::PI / 2))``

  The overall width of the fan, in radians. Angle of zero is a vertical card. Further negative angles widen the fan counter-clockwise and positive angles widen the fan clockwise.

margin
  default: ``75``

  the margin around the entire image. Supports :doc:`/units`.

fill_color
  default: ``:white``

  Backdrop color. See :doc:`/colors`.

.. include:: /args/trim.rst

file
  default: ``'hand.png'``

  The file to save relative to the current directory. Will overwrite without warning.

.. include:: /args/output_dir.rst
.. include:: /args/range.rst

Examples
--------
