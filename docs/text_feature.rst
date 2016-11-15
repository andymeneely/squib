The Mighty text Method
======================

The :doc:`/dsl/text` method is a particularly powerful method with a ton of options. Be sure to check the option-by-option details in the DSL reference, but here are the highlights.

Fonts
-----

To set the font, your ``text`` method call will look something like this::

  text str: "Hello", font: 'MyFont Bold 32'


The ``'MyFont Bold 32'`` is specified as a "Pango font string", which can involve `a lot of options <http://ruby-gnome2.osdn.jp/hiki.cgi?Pango%3A%3AFontDescription#Pango%3A%3AFontDescription.new>`_ including backup font families, size, all-caps, stretch, oblique, italic, and degree of boldness. (These options are only available if the underlying font supports them, however.) Here's are some :doc:`/dsl/text` calls with different Pango font strings::

  text str: "Hello", font: 'Sans 18'
  text str: "Hello", font: 'Arial,Verdana weight=900 style=oblique 36'
  text str: "Hello", font: 'Times New Roman,Sans 25'


Finally, Squib's ``text`` method has options such as ``font_size`` that allow you to override the font string. This means that you can set a blanket font for the whole deck, then adjust sizes from there. This is useful with layouts and ``extends`` too (see :doc:`/layouts`).

.. note::

  When the font has a space in the name (e.g. Times New Roman), you'll need to put a backup to get Pango's parsing to work. In some operating systems, you'll want to simply end with a comma::

    text str: "Hello", font: 'Times New Roman, 25'

.. note::

  Most of the font rendering is done by a combination of your installed fonts, your OS, and your graphics card. Thus, different systems will render text slightly differently.

Width and Height
------------------

By default, Pango text boxes will scale the text box to whatever you need, hence the ``:native`` default. However, for most of the other customizations to work (e.g. center-aligned) you'll need to specify the width. If both the width and the height are specified and the text overflows, then the ``ellipsize`` option is consulted to figure out what to do with the overflow. Also, the ``valign`` will only work if ``height`` is also set to something other than ``:native``.

Hints
-----

Laying out text by typing in numbers can be confusing. What Squib calls "hints" is merely a rectangle around the text box. Hints can be turned on globally in the config file, using the :doc:`/dsl/hint` method, or in an individual text method. These are there merely for prototyping and are not intended for production. Additionally, these are not to be conflated with "rendering hints" that Pango and Cairo mention in their documentation.

Extents
-------

Sometimes you want size things based on the size of your rendered text. For example, drawing a rectangle around card's title such that the rectangle perfectly fits. Squib returns the final rendered size of the text so you can work with it afterward. It's an array of hashes that correspond to each card. The output looks like this::

  Squib::Deck.new(cards: 2) do
    extents = text(str: ['Hello', 'World!'])
    puts extents
  end

will output::

  [{:width=>109, :height=>55}, {:width=>142, :height=>55}] # Hello was 109 pixels wide, World 142 pixels

Embedding Images
----------------

Squib can embed icons into the flow of text. To do this, you need to define text keys for Squib to look for, and then the corresponding files. The object given to the block is a ``TextEmbed``, which supports PNG and SVG. Here's a minimal example::

  text(str: 'Gain 1 :health:') do |embed|
    embed.svg key: ':health:', file: 'heart.svg'
  end

Markup
------

See :ref:`Markup <text-markup>` in  :doc:`/dsl/text`.

Samples
-------

These samples are maintained in the `repository here <https://github.com/andymeneely/squib/tree/master/samples>`_ in case you need some of the assets referenced.

Sample: _text.rb
^^^^^^^^^^^^^^^^

.. literalinclude:: ../samples/text/_text.rb
  :language: ruby
  :linenos:

.. raw:: html

  <img src="text/_text_00_expected.png" width=600 class="figure">

Sample: text_options.rb
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ../samples/text_options.rb
  :language: ruby
  :linenos:

Sample: embed_text.rb
^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ../samples/embed_text.rb
  :language: ruby
  :linenos:


Sample: config_text_markup.rb
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ../samples/config_text_markup.rb
  :language: ruby
  :linenos:

.. literalinclude:: ../samples/config_text_markup.yml
  :language: ruby
  :linenos:

.. literalinclude:: ../samples/config_disable_quotes.yml
  :language: ruby
  :linenos:
