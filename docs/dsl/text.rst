text
====

Renders a string at a given location, width, alignment, font, etc.

Unix newlines are interpreted even on Windows (i.e. ``"\n"``).

Options
-------
.. include:: /args/expansion.rst

str
  default: ``''``

  the string to be rendered. Must support `#to_s`. If the card responds to `#each`, it's mapped out one at a time across the cards.

font
  default: ``'Arial 36'``

  the Font description string, including family, styles, and size. (e.g. `'Arial bold italic 12'`). For the official documentation, see the [Pango docs](http://ruby-gnome2.sourceforge.jp/hiki.cgi?Pango%3A%3AFontDescription#style). This [description](http://www.pygtk.org/pygtk2reference/class-pangofontdescription.html) is also quite good.

font_size
  default: ``nil``

  an override of font string description, for scaling the font according to the size of the string

.. include:: /args/xy.rst

markup:
  default: ``false``

  Enable markup parsing of `str` using the HTML-like Pango Markup syntax, defined [here](http://ruby-gnome2.sourceforge.jp/hiki.cgi?pango-markup) and [here](https://developer.gnome.org/pango/stable/PangoMarkupFormat.html). Also does other replacements, such as smart quotes, curly apostraphes, en- and em-dashes, and explict ellipses (not to be confused with ellipsize option). See README for full explanation.

width
  default: ``:auto``

  the width of the box the string will be placed in. Stretches to the content by default.. Supports Unit Conversion, see {file:README.md#Units Units}.

height
  default: :``auto``

  the height of the box the string will be placed in. Stretches to the content by default. Supports Unit Conversion, see {file:README.md#Units Units}.

wrap
  default: ``:word_char``

  [:none, :word, :char, :word_char, true, false] (:word_char) When height is set, determines the behavior of how the string wraps. The `:word_char` option will break at words, but then fall back to characters when the word cannot fit.    #

#   Options are `:none, :word, :char, :word_char`. Also: `true` is the same as `:word_char`, `false` is the same as `:none`. Default `:word_char`

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

  the width of the outside stroke. Supports Unit Conversion, see {file:README.md#Units Units}.

stroke_color
  default: ``:black``

  the color with which to stroke the outside of the rectangle. {file:README.md#Specifying_Colors___Gradients Specifying Colors & Gradients}

stroke_strategy
  default: ``:fill_first``

  specify whether the stroke is done before (thinner) or after (thicker) filling the shape. [:fill_first, :stroke_first]

dash
  default: ``''``

  define a dash pattern for the stroke. Provide a string with space-separated numbers that define the pattern of on-and-off alternating strokes, measured in pixels by defautl. Supports Unit Conversion, see {file:README.md#Units Units} (e.g. `'0.02in 0.02in'`).

hint
  default: ``:nil`` (i.e. no hint)

  draw a rectangle around the text with the given color. Overrides global hints (see {Deck#hint}).

color
  default: [String] (:black) the color the font will render to. Gradients supported. See {file:README.md#Specifying_Colors___Gradients Specifying Colors}

.. include:: /args/draw.rst
.. include:: /args/range.rst
.. include:: /args/layout.rst

Examples
--------

.. raw:: html

  <script src="https://gist.github.com/andymeneely/52d7b8e332194946bc69.js"></script>
