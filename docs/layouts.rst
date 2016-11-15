Layouts are Squib's Best Feature
================================

Working with tons of options to a method can be tiresome. Ideally everything in a game prototype should be data-driven, easily changed, and your Ruby code should readable without being littered with `magic numbers <http://stackoverflow.com/questions/47882/what-is-a-magic-number-and-why-is-it-bad>`_.

For this, most Squib methods have a ``layout`` option. Layouts are a way of setting default values for any parameter given to the method. They let you group things logically, manipulate options, and use built-in stylings.

Think of layouts and DSL calls like CSS and HTML: you can always specify style in your logic (e.g. directly in an HTML tag), but a cleaner approach is to group your styles together in a separate sheet and work on them separately.

To use a layout, set the ``layout:`` option on ``Deck.new`` to point to a YAML file. Any command that allows a ``layout`` option can be set with a Ruby symbol or string, and the command will then load the specified options. The individual command can also override these options.

For example, instead of this::

  # deck.rb
  Squib::Deck.new do
    rect x: 75, y: 75, width: 675, height: 975
  end

You can put your logic in the layout file and reference them::

  # custom-layout.yml
  bleed:
    x: 75
    y: 75
    width: 975
    height: 675

Then your script looks like this::

  # deck.rb
  Squib::Deck.new(layout: 'custom-layout.yml') do
    rect layout: 'bleed'
  end

The goal is to make your Ruby code separate the data decisions from logic. For the above example, you are separating the decision to draw rectangle around the "bleed" area, and then your YAML file is defining specifically what "bleed" actually means. (Who is going to remember that ``x: 75`` means "bleed area"??) This process of separating logic from data makes your code more readable, changeable, and maintainable.

.. warning::

   YAML is very finnicky about not allowing tab characters. Use two spaces for indentation instead. If you get a ``Psych`` syntax error, this is likely the culprit. Indendation is also strongly enforced in Yaml too. See the `Yaml docs <http://www.yaml.org/YAML_for_ruby.html>`_ for more info.

Order of Precedence for Options
-------------------------------

Layouts will override Squib's system defaults, but are overriden by anything specified in the command itself. Thus, the order of precedence looks like this:

  1. Use what the DSL method specified, e.g. ``rect x: 25``
  2. If anything was not yet specified, use what was given in a layout (if a layout was specified in the command and the file was given to the Deck). e.g. ``rect layout: :bleed``
  3. If still anything was not yet specified, use what was given in Squib's defaults as defined in the :doc:`dsl/index`.

For example, back to our example::

  # custom-layout.yml
  bleed:
    x: 0.25in
    y: 0.25in
    width: 2.5in
    height: 3.5in

(Note that this example makes use of :doc:`/units`)

Combined with this script:

.. code-block:: ruby

  # deck.rb
  Squib::Deck.new(layout: 'custom-layout.yml') do
    rect layout: 'bleed', x: 50
  end

The options that go into ``rect`` will be:

  * ``x`` will be 50 because it's specified in the DSL method and overrides the layout
  * ``y``, ``width``, and ``height`` were specified in the layout file, so their values are used
  * The rect's ``stroke_color`` (and others options like it) was never specified anywhere, so the default for ``rect`` is used - as discussed in :doc:`parameters`.

.. note::

 Defaults are not global for the name of the option - they are specific to the method itself. For example, the default ``fill_color`` for ``rect`` is ``'#0000'`` but for ``showcase`` it's ``:white``.

.. note::

  Layouts work with *all* options (for DSL methods that support layouts), so you can use options like ``file`` or ``font`` or whatever is needed.

.. warning::

  If you provide an option in the Yaml file that is not supported by the DSL method, the DSL method will simply ignore it. Same behavior as described in :doc:`parameters`.


When Layouts Are Similar, Use ``extends``
-----------------------------------------

Using layouts are a great way of keeping your Ruby code clean and concise. But those layout Yaml files can get pretty long. If you have a bunch of icons along the top of a card, for example, you're specifying the same ``y`` option over and over again. This is annoyingly verbose, and what if you want to move all those icons downward at once?

Squib provides a way of reusing layouts with the special `extends`` key. When defining an ```extends`` key, we can merge in another key and modify its data coming in if we want to. This allows us to do things like place text next to an icon and be able to move them with each other. Like this::

  # If we change attack, we move defend too!
  attack:
    x: 100
    y: 100
  defend:
    extends: attack
    x: 150
    #defend now is {:x => 150, :y => 100}

Over time, using ``extends`` saves you a lot of space in your Yaml files while also giving more structure and readability to the file itself.

You can also **modify** data as they get passed through extends::

  # If we change attack, we move defend too!
  attack:
    x: 100
  defend:
    extends: attack
    x: += 50
    #defend now is {:x => 150, :y => 100}

The following operators are supported within evaluating ``extends``
  * ``+=`` will add the giuven number to the inherited number
  * ``-=`` will subtract the given number from the inherited number

Both operators also support :doc:`/units`

From a design point of view, you can also extract out a base design and have your other layouts extend from them::

  top_icons:
    y: 100
    font: Arial 36
  attack:
    extends: top_icon
    x: 25
  defend:
    extends: top_icon
    x: 50
  health:
    extends: top_icon
    x: 75
  # ...and so on

.. note::

   Those fluent in Yaml may notice that ``extends`` key is similar to Yaml's `merge keys <http://www.yaml.org/YAML_for_ruby.html#merge_key>`_. Technically, you can use these together - but I just recommend sticking with ``extends`` since it does what merge keys do *and more*. If you do choose to use both ``extends`` and Yaml merge keys, the Yaml merge keys are processed first (upon Yaml parsing), then ``extends`` (after parsing).

Yes, ``extends`` is Multi-Generational
--------------------------------------

As you might expect, ``extends`` can be composed multiple times::

  socrates:
    x: 100
  plato:
    extends: socrates
    x: += 10    # evaluates to 150
  aristotle:
    extends: plato
    x: += 20    # evaluates to 150

Yes, ``extends`` has Multiple Inheritance
-----------------------------------------

If you want to extend multiple parents, it looks like this::

  socrates:
    x: 100
  plato:
    y: 200
  aristotle:
    extends:
      - socrates
      - plato
    x: += 50    # evaluates to 150

If multiple keys override the same keys in a parent, the later ("younger") child in the ``extends`` list takes precedent. Like this::

  socrates:
    x: 100
  plato:
    x: 200
  aristotle:
    extends:
      - plato    # note the order here
      - socrates
    x: += 50     # evaluates to 150 from socrates


Multiple Layout Files get Merged
--------------------------------

Squib also supports the combination of multiple layout files. If you provide an ``Array`` of files then Squib will merge them sequentially. Colliding keys will be completely re-defined by the later file. The ``extends`` key is processed after *each file*, but can be used across files. Here's an example::

  # load order: a.yml, b.yml

  ##############
  # file a.yml #
  ##############
  grandparent:
    x: 100
  parent_a:
    extends: grandparent
    x: += 10   # evaluates to 110
  parent_b:
    extends: grandparent
    x: += 20   # evaluates to 120

  ##############
  # file b.yml #
  ##############
  child_a:
    extends: parent_a  # i.e. extends a layout in a separate file
    x: += 3    # evaluates to 113 (i.e 110 + 3)
  parent_b:    # redefined
    extends: grandparent
    x: += 30   # evaluates to 130 (i.e. 100 + 30)
  child_b:
    extends: parent_b
    x: += 3    # evaluates to 133 (i.e. 130 + 3)

This can be helpful for:
  * Creating a base layout for structure, and one for full color for easier color/black-and-white switching
  * Sharing base layouts with other designers

Squib Comes with Built-In Layouts
---------------------------------

Why mess with x-y coordinates when you're first prototyping your game? Just use a built-in layout to get your game to the table as quickly as possible.

If your layout file is not found in the current directory, Squib will search for its own set of layout files.  The latest the development version of these can be found `on GitHub <https://github.com/andymeneely/squib/tree/master/lib/squib/layouts>`_.

Contributions in this area are particularly welcome!!

The following depictions of the layouts are generated with `this script <https://github.com/andymeneely/squib/tree/master/samples/layouts/builtin_layouts.rb>`_

fantasy.yml
~~~~~~~~~~~

.. raw:: html

  <img src="layouts/expected_layouts_builtin_fantasy_00.png"
    class="figure" width=350>

https://github.com/andymeneely/squib/tree/master/lib/squib/layouts/fantasy.yml

economy.yml
~~~~~~~~~~~

.. raw:: html

  <img src="layouts/expected_layouts_builtin_economy_00.png"
    class="figure" width=350>

https://github.com/andymeneely/squib/tree/master/lib/squib/layouts/economy.yml

tuck_box.yml
~~~~~~~~~~~~

Based on TheGameCrafter's template.

.. raw:: html

  <img src="layouts/expected_layouts_builtin_tuck_box_00.png"
    class="figure" width=450>

https://github.com/andymeneely/squib/tree/master/lib/squib/layouts/tuck_box.yml


hand.yml
~~~~~~~~

.. raw:: html

  <img src="layouts/expected_layouts_builtin_hand_00.png"
    class="figure" width=350>

https://github.com/andymeneely/squib/tree/master/lib/squib/layouts/hand.yml

playing_card.yml
~~~~~~~~~~~~~~~~

.. raw:: html

  <img src="layouts/expected_layouts_builtin_playing_card_00.png"
    class="figure" width=350>

https://github.com/andymeneely/squib/tree/master/lib/squib/layouts/playing_card.yml

See Layouts in Action
---------------------

`This sample <https://github.com/andymeneely/squib/tree/master/samples/>`_ demonstrates many different ways of using and combining layouts.

`This sample <https://github.com/andymeneely/squib/tree/master/samples/>`_ demonstrates built-in layouts based on popular games (e.g. ``fantasy.yml`` and ``economy.yml``)
