XYWH Shorthands
===============

For the arguments ``x``, ``y``, ``width``, and ``height``, a few convenient shorthands are available.

* ``middle`` for ``x`` and ``width`` refer to the deck's width / 2
* ``middle`` for ``y`` and ``height`` refer to the deck's height / 2
* ``deck`` refers to the deck's width for ``x`` and ``width``
* ``deck`` refers to the deck's height for ``y`` and ``height``
* You can offset from the middle by using +, -, and /, e.g. ``middle + 1in``
* You can offset from the width or height using, e.g. ``width - 1in`` or ``height - 2mm``
* Works with the ``cell`` unit as well, e.g. `middle + 1 cell`. See :doc:`units`.

These are all passed as strings. So you will need to quote them in Ruby, or just plain in your layout YAML.

Note that the following are NOT supported:

* The `+=` operator when using `extends` in a layout file

Samples
-------

_shorthands.rb
^^^^^^^^^^^^^^

.. literalinclude:: ../samples/units/_shorthands.rb
  :language: ruby
  :linenos:

