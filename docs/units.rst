Unit Conversion
===============

By default, Squib thinks in pixels. This decision was made so that we can have pixel-perfect layouts without automatically scaling everything, even though working in units is sometimes easier. We provide some conversion methods, including looking for strings that end in "in", "cm", or "mm" and computing based on the current DPI. The dpi is set on `Squib::Deck.new` (not `config.yml`).

Cells
-----

A "cell" is a custom unit in Squib that, by default, refers to ``37.5`` pixels. In a 300 DPI situation (i.e. the default), that refers to a 1/8 inch or 3.175mm. This tends to be a standard unit of measure in a lot of templates. By specifying your units in cells, you can increase your rapid prototyping without having to multiply 37.5.

The ``cell_px`` measure is configurable. See :doc:`config`.

To use the cell unit, you need to give Squib a string ending in `cell`, `cells`, or just `c`. For example:

* ``2 cells``
* ``1cell``
* ``0.5c``

See more examples below.

Samples
-------

_units.rb
^^^^^^^^^

Here are some examples, which `lives here <https://github.com/andymeneely/squib/tree/master/samples/units.rb>`_

.. literalinclude:: ../samples/units/_units.rb
  :language: ruby
  :linenos:

.. raw:: html

  <img src="units/units_00_expected.png" class="figure">

_cells.rb
^^^^^^^^^

.. literalinclude:: ../samples/units/_cells.rb
  :language: ruby
  :linenos:

.. raw:: html

  <img src="units/cells_00_expected.png" class="figure">