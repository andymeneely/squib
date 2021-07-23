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

shadow_radius
  default: ``nil``

  adds a drop shadow behind the card just before rendering, when non-nil. Does nothing when set to nil.

  `Drop Shadows`. A larger radius extends the blur's reach. A radius of ``0`` will enable the feature but not do any blurring (which can still look good!).
  The final image will have a new width of: ``w + shadow_offset_x + (3 * shadow_radius) - (2 * shadow_trim) - (2 * trim)``, and similar for height.
  The image will be painted at ``shadow_radius, shadow_radius`` in the new image.
  This drop shadow happens before rendering and does not alter the original card graphic.
  At this stage, the feature will just draw a rectangle and blur from there. So if your card has transparency (other than from ``trim_radius``), from, say, a circular chit, then this won't work. We're working on a better implementation.
  See [blur algorithm](https://github.com/rcairo/rcairo/blob/master/lib/cairo/context/blur.rb) for details on blur implementation. Recommended range: 3-10 pixels. Supports :doc:`/units`.

shadow_offset_x
  default: ``3``

  the horizontal distance that the drop shadow will be shifted beneath the final image.
  Ignored when ``shadow_radius`` is ``nil``. See ``shadow_radius`` above for drop shadow details.
  Supports :doc:`/units`.

shadow_offset_y
  default: ``3``

  Ignored when `shadow_radius` is ``nil``. See ``shadow_radius`` above for drop shadow details.
  Supports :doc:`/units`.

shadow_trim
  default: ``0``

  the space around the edge of the output image trimmed when a drop shadow is drawn.
  A negative number here would enlarge the margin on the right and bottom only.
  Ignored when `shadow_radius` is ``nil``. See ``shadow_radius`` above for drop shadow details.
  Supports :doc:`/units`.

shadow_color
  default: ``:black``

  the color or gradient of the drop shadow. See :doc:`/colors`.

  `Note about gradients:` while gradients are technically supported here, Squib will do the blurring for you. But, using a gradient here does give you enormous control over the softness of the shadow. See example below of doing a custom gradient for customizing your look.


.. include:: /args/range.rst

Examples
--------

This sample `lives here <https://github.com/andymeneely/squib/tree/master/samples/shadows>`_.

.. literalinclude:: ../../samples/shadows/_shadow.rb
  :language: ruby
  :linenos:

.. raw:: html

  <img src="../saves/with_shadow_00_expected.png" class="figure">
  <img src="../saves/with_shadow_test_00_expected.png" class="figure">
