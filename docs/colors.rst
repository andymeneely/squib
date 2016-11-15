Specifying Colors & Gradients
=============================

Colors
------

by hex-string
^^^^^^^^^^^^^

You can specify a color via the standard hexadecimal string for RGB (as in HTML and CSS).  You also have a few other options as well. You can use:

  * 12-bit (3 hex numbers), RGB. e.g. ``'#f08'``
  * 24-bit (6 hex numbers), RRGGBB. e.g. ``'#ff0088'``
  * 48-bit (9 hex numbers), RRRGGGBBB. e.g. ``'#fff000888'``


Additionally, you can specify the alpha (i.e. transparency) of the color as RGBA. An alpha of ``0`` is full transparent, and ``f`` is fully opaque. Thus, you can also use:

  * 12-bit (4 hex numbers), RGBA. e.g. ``'#f085'``
  * 24-bit (8 hex numbers), RRGGBBAA. e.g. ``'#ff008855'``
  * 48-bit (12 hex numbers), RRRGGGBBBAAA. e.g. ``'#fff000888555'``

The ``#`` at the beginning is optional, but encouraged for readability. In layout files (described in :doc:`/layouts`), the ``#`` character will initiate a comment in Yaml. So to specify a color in a layout file, just quote it::

  # this is a comment in yaml
  attack:
    fill_color: '#fff'


by name
^^^^^^^

Under the hood, Squib uses the rcairo `color parser <https://github.com/rcairo/rcairo/blob/master/lib/cairo/color.rb>`_ to accept around 300 named colors. The full list can be found `here <https://github.com/rcairo/rcairo/blob/master/lib/cairo/colors.rb>`_.

Names of colors can be either strings or symbols, and case does not matter. Multiple words are separated by underscores. For example, ``'white'``, ``:burnt_orange``, or ``'ALIZARIN_CRIMSON'`` are all acceptable names.

by custom name
^^^^^^^^^^^^^^

In your ``config.yml``, as described in :doc:`/config`, you can specify custom names of colors. For example, ``'foreground'``.

Gradients
---------

In most places where colors are allowed, you may also supply a string that defines a gradient. Squib supports two flavors of gradients: linear and radial. Gradients are specified by supplying some xy coordinates, which are relative to the card (not the command). Each stop must be between ``0.0`` and ``1.0``, and you can supply as many as you like. Colors can be specified as above (in any of the hex notations or built-in constant). If you add two or more colors at the same stop, then the gradient keeps the colors in the in order specified and treats it like sharp transition.

The format for linear gradient strings look like this::

  '(x1,y1)(x2,y2) color1@stop1 color2@stop2'

The xy coordinates define the angle of the gradient.

The format for radial gradients look like this::

  '(x1,y1,radius1)(x2,y2,radius2) color1@stop1 color2@stop2'

The coordinates specify an inner circle first, then an outer circle.

In both of these formats, whitespace is ignored between tokens so as to make complex gradients more readable.

If you need something more powerful than these two types of gradients (e.g. mesh gradients), then we suggest encapsulating your logic within an SVG and using the :doc:`/dsl/svg` method to render it.

Samples
-------

Code is maintained in the `repository here <https://github.com/andymeneely/squib/tree/master/samples>`_ in case you need some of the assets referenced.

Sample: colors and color constants
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ../samples/colors/_colors.rb
  :language: ruby
  :linenos:

.. raw:: html

  <img src="colors/colors_00_expected.png" width=600 class="figure">

  <img src="colors/color_constants_00_expected.png" width=600 class="figure">

Sample: gradients
^^^^^^^^^^^^^^^^^

.. literalinclude:: ../samples/colors/_gradients.rb
  :language: ruby
  :linenos:

.. raw:: html

  <img src="colors/gradient_00_expected.png" width=600 class="figure">
