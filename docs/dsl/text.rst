text
====

Renders a string at a given location, width, alignment, font, etc.

Unix newlines are interpreted even on Windows (i.e. ``"\n"``).


Options
-------
.. include:: /args/expansion.rst

str
  default: ``''``

  the string to be rendered. Must support ``#to_s``.

font
  default: ``'Arial 36'``

  the Font description string, including family, styles, and size. (e.g. ``'Arial bold italic 12'``). For the official documentation, see the `Pango font string docs <http://ruby-gnome2.sourceforge.jp/hiki.cgi?Pango%3A%3AFontDescription#style>`_. This `description <http://www.pygtk.org/pygtk2reference/class-pangofontdescription.html>`_ is also quite good.

font_size
  default: ``nil``

  an override of font string description (i.e. ``font``).

.. include:: /args/xy.rst

markup:
  default: ``false``

  When set to true, various extra styles are allowed. See :ref:`Markup <text-markup>`.

width
  default: ``:auto``

  the width of the box the string will be placed in. Stretches to the content by default.. Supports :doc:`/units`.

height
  default: ``:auto``

  the height of the box the string will be placed in. Stretches to the content by default. Supports :doc:`/units`.

wrap
  default: ``:word_char``

   when ``width`` is set, determines the behavior of how the string wraps. The ``:word_char`` option will break at words, but then fall back to characters when the word cannot fit. Options are ``:none``, ``:word``, ``:char``, ``:word_char``. Also: ``true`` is the same as ``:word_char``, ``false`` is the same as ``:none``.

spacing
  default: ``0``

  Adjust the spacing when the text is multiple lines. No effect when the text does not wrap.

align
  default: ``:left``

  The alignment of the text. [:left, right, :center]

justify
  default: ``false``

  toggles whether or not the text is justified or not.

valign
  default: ``:top``

  When width and height are set, align text vertically according to the ink extents of the text. [:top, :middle, :bottom]

ellipsize
  default: ``:end``

  When width and height are set, determines the behavior of overflowing text. Also: `true` maps to `:end` and `false` maps to `:none`. Default `:end` [:none, :start, :middle, :end, true, false]. Also, as mentioned in :doc:`/config`, if text is ellipsized a warning is thrown.

angle
  default: ``0``

  Rotation of the text in radians. Note that this rotates around the upper-left corner of the text box, making the placement of x-y coordinates slightly tricky.

stroke_width
  default: ``0.0``

  the width of the outside stroke. Supports :doc:`/units`, see {file:README.md#Units Units}.

stroke_color
  default: ``:black``

  the color with which to stroke the outside of the rectangle. {file:README.md#Specifying_Colors___Gradients Specifying Colors & Gradients}

stroke_strategy
  default: ``:fill_first``

  specify whether the stroke is done before (thinner) or after (thicker) filling the shape. [:fill_first, :stroke_first]

dash
  default: ``''``

  define a dash pattern for the stroke. Provide a string with space-separated numbers that define the pattern of on-and-off alternating strokes, measured in pixels by defautl. Supports :doc:`/units` (e.g. ``'0.02in 0.02in'``).

hint
  default: ``:nil`` (i.e. no hint)

  draw a rectangle around the text with the given color. Overrides global hints (see {Deck#hint}).

color
  default: [String] (:black) the color the font will render to. Gradients supported. See {file:README.md#Specifying_Colors___Gradients Specifying Colors}

.. include:: /args/draw.rst
.. include:: /args/range.rst
.. include:: /args/layout.rst

.. _text-markup:

Markup
------

If you want to do specialized formatting within a given string, Squib has lots of options. By setting ``markup: true``, you enable tons of text processing. This includes:

  * Pango Markup. This is an HTML-like formatting language that specifies formatting inside your string. Pango Markup essentially supports any formatting option, but on a letter-by-letter basis. Such as: font options, letter spacing, gravity, color, etc. See the `Pango markup docs  <https://developer.gnome.org/pango/stable/PangoMarkupFormat.html>`_ for details.
  * Quotes are converted to their curly counterparts where appropriate.
  * Apostraphes are converted to curly as well.
  * LaTeX-style quotes are explicitly converted (````like this''``)
  * Em-dash and en-dash are converted with triple and double-dashes respectively (``--`` is an en-dash, and ``---`` becomes an em-dash.)
  * Ellipses can be specified with ``...`` (three periods). Note that this is entirely different from the ``ellipsize`` option (which determines what to do with overflowing text).

  A few notes:
    * Smart quoting assumes the UTF-8 character set by default. If you are in a different character set and want to change how it behaves
    * Pango markup uses an XML/HTML-ish processor. Some characters require HTML-entity escaping (e.g. ``&amp;`` for ``&``)


  You can also disable the auto-quoting mechanism by setting ``smart_quotes: false`` in your config. Explicit replacements will still be performed. See :doc:`/config`

Embedded Icons
--------------

The ``text`` method will also respond to a block. The object that gets passed to this block allows for embedding images into the flow of your text. The following methods are supported::

  text(str: 'Take 1 :tool: and gain 2 :health:') do |embed|
    embed.svg key: ':tool:', file: 'tool.svg'
    embed.png key: ':health:', file: 'health.png'
  end

embed.svg
^^^^^^^^^
.. include:: /args/expansion.rst


key
  default: ``'*'``

  the string to replace with the graphic. Can be multiple letters, e.g. ``':tool:'``


file
  default: ``''``

  file(s) to read in, relative to the root directory or ``img_dir`` if set in the config.

id
  default: ``nil``

  if set, then only render the SVG element with the given id. Prefix '#' is optional. Note: the x-y coordinates are still relative to the SVG document's page.


force_id
  default: ``false``

  if set, then this svg will not be rendered at all if the id is empty or nil. If not set, the entire SVG is rendered.

layout
  default: ``nil``

  entry in the layout to use as defaults for this command. See :doc:`/layouts`

width
  default: ``:native``

  the width of the image rendered. Does not support ``:scale`` (`yet <https://github.com/andymeneely/squib/issues/160>`_)

height
  default: ``:native``

  the height the height of the image rendered. Does not support ``:scale`` (`yet <https://github.com/andymeneely/squib/issues/160>`_)

dx
  default: ``0``

  "delta x", or adjust the icon horizontally by x pixels

dy
  default: ``0``

  "delta y", or adjust the icon vertically by y pixels

flip_horiztonal
  default: ``false``

  Flip this image about its center horizontally (i.e. left becomes right and vice versa).

flip_vertical
  default: ``false``

  Flip this image about its center verticall (i.e. top becomes bottom and vice versa).

alpha
  default: ``1.0``

  the alpha-transparency percentage used to blend this image.

angle
  default: ``0``

  rotation of the in radians. Note that this rotates around the upper-left corner, making the placement of x-y coordinates slightly tricky.

embed.png
^^^^^^^^^

.. include:: /args/expansion.rst

key
  default: ``'*'``

  the string to replace with the graphic. Can be multiple letters, e.g. ``':tool:'``

file
  default: ``''``

  file(s) to read in, relative to the root directory or ``img_dir`` if set in the config.

layout
  default: ``nil``

  entry in the layout to use as defaults for this command. See :doc:`/layouts`

width
  default: ``:native``

  the width of the image rendered.

height
  default: ``:native``

  the height the height of the image rendered.

dx
  default: ``0``

  "delta x", or adjust the icon horizontally by x pixels

dy
  default: ``0``

  "delta y", or adjust the icon vertically by y pixels

flip_horiztonal
  default: ``false``

  Flip this image about its center horizontally (i.e. left becomes right and vice versa).

flip_vertical
  default: ``false``

  Flip this image about its center verticall (i.e. top becomes bottom and vice versa).

alpha
  default: ``1.0``

  the alpha-transparency percentage used to blend this image.

blend
  default: ``:none``

  the composite blend operator used when applying this image. See Blend Modes at http://cairographics.org/operators.
  The possibilties include :none, :multiply, :screen, :overlay, :darken, :lighten, :color_dodge, :color_burn, :hard_light, :soft_light, :difference, :exclusion, :hsl_hue, :hsl_saturation, :hsl_color, :hsl_luminosity. String versions of these options are accepted too.


mask
  default: ``nil``

  Accepts a color (see :doc:`/colors`). If specified, the image will be used as a mask for the given color/gradient. Transparent pixels are ignored, opaque pixels are the given color. Note: the origin for gradient coordinates is at the given x,y, not at 0,0 as it is most other places.

angle
  default: ``0``

  rotation of the in radians. Note that this rotates around the upper-left corner, making the placement of x-y coordinates slightly tricky.



Examples
--------

See :doc:`/text_feature`.
