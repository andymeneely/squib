Unit Conversion
===============

By default, Squib thinks in pixels. This decision was made so that we can have pixel-perfect layouts without automatically scaling everything, even though working in units is sometimes easier. We provide some conversion methods, including looking for strings that end in "in", "cm", or "mm" and computing based on the current DPI. The dpi is set on `Squib::Deck.new` (not `config.yml`).

Here are some examples, which `lives here <https://github.com/andymeneely/squib/tree/master/samples/units.rb>`_

.. literalinclude:: ../samples/units/_units.rb
  :language: ruby
  :linenos:

.. raw:: html

  <img src="units/units_00_expected.png" class="figure">
