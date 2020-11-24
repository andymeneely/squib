XYWH Shorthands
===============

For the arguments ``x``, ``y``, ``width``, and ``height``, a few convenient shorthands are available.

* ``middle`` for ``x`` and ``width`` refer to the deck's width / 2
* ``middle`` for ``y`` and ``height`` refer to the deck's height / 2
* The word ``center`` behaves the same way
* ``deck`` refers to the deck's width for ``x`` and ``width``
* ``deck`` refers to the deck's height for ``y`` and ``height``
* You can offset from the middle by using + or - operators, e.g. ``middle + 1in``
* You can offset from the deck width or height using the + or - operators, e.g. ``deck - 1in`` or ``deck - 2mm``
* You can offset from the deck width or height using, e.g. ``deck / 3``
* Works with all unit conversion too, e.g. `middle + 1 cell`. See :doc:`units`.

These are all passed as strings. So you will need to quote them in Ruby, or just plain in your layout YAML.

Note that the following are NOT supported:

* The `+=` operator when using `extends` in a layout file
* Complicated formulas. We're not evaluating this as code, we're looking for these specific patterns and applying them. Anything more complicated you'll have to handle with Ruby code.

Samples
-------

_shorthands.rb
^^^^^^^^^^^^^^

.. literalinclude:: ../samples/units/_shorthands.rb
  :language: ruby
  :linenos:

