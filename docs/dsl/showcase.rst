showcase
========

Renders a range of cards in a showcase as if they are sitting in 3D on a reflective surface.

Options
-------

.. include:: /args/trim.rst

scale
  default: ``0.8``

  Percentage of original width of each (trimmed) card to scale to. Must be between 0.0 and 1.0, but starts looking bad around 0.6.

offset
  default: ``1.1``

  Percentage of the scaled width of each card to shift each offset. e.g. 1.1 is a 10% shift, and 0.95 is overlapping by 5%

fill_color
  default: ``:white``

  Backdrop color. Usually black or white. See :doc:`/colors`.

reflect_offset
  default: ``15``

  The number of pixels between the bottom of the card and the reflection. See :doc:`/units`

reflect_strength
  default: ``0.2``

  The starting alpha transparency of the reflection (at the top of the card). Percentage between 0 and 1. Looks more realistic at low values since even shiny surfaces lose a lot of light.

reflect_percent
  default: ``0.25``

  The length of the reflection in percentage of the card. Larger values tend to make the reflection draw just as much attention as the card, which is not good.

face
  default: ``:left``

  which direction the cards face. Anything but ``:right`` will face left

margin
  default: ``75``

  the margin around the entire image. Supports :doc:`/units`

fill_color
  default: ``:white``

  Backdrop color. Supports :doc:`/colors`.

file
  default: ``'showcase.png'``

  The file to save relative to the current directory. Will overwrite without warning.

.. include:: /args/output_dir.rst
.. include:: /args/range.rst

Examples
--------

This sample `lives here <https://github.com/andymeneely/squib/tree/master/samples/saves>`_.

.. literalinclude:: ../../samples/saves/_showcase.rb
  :language: ruby
  :linenos:

.. raw:: html

  <img src="../saves/showcase_expected.png" class="figure">
  <img src="../saves/showcase2_expected.png" class="figure">
