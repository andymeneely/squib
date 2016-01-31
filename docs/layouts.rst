Layouts are Squib's Best Feature
================================

Working with tons of options can be tiresome. Ideally everything in a game prototype should be data-driven, easily changed, and your Ruby code should readable without being littered with `magic numbers <http://stackoverflow.com/questions/47882/what-is-a-magic-number-and-why-is-it-bad>`_.

For this, most Squib methods have a ``layout`` option.  In essence, layouts are a way of setting default values for any parameter given to the method. They let you group things logically, manipulate options, and use built-in stylings.

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

The goal is to make your Ruby code more separate data from logic, which in turn makes your code more readable and maintainable. With `extends` (see below), layouts become even more powerful in keeping you from repeating yourself.

.. warning::

  Note: YAML is very finnicky about not allowing tab characters. Use two spaces for indentation instead. If you get a ``Psych`` syntax error, this is likely the culprit. Indendation is also strongly enforced in Yaml too. See the `Yaml docs <http://www.yaml.org/YAML_for_ruby.html>`_ for more info.

### Order of Precedence

Layouts will override Squib's system defaults, but are overriden by anything specified in the command itself. Thus, the order of precedence looks like this:

* Use what the command specified
* If anything was not yet specified, use what was given in a layout (if a layout was specified in the command and the file was given to the Deck)
* If still anything was not yet specified, use what was given in Squib's defaults.

### Special key: `extends`

Squib provides a way of reusing layouts with the special `extends` key. When defining an `extends` key, we can merge in another key and modify data coming in if we want to. This allows us to do things like place text next to an icon and be able to move them with each other. Like this:

```yaml
# If we change the xy of attack, we move defend too!
attack:
  x: 100
  y: 100
  radius: 100
defend:
  extends: attack
  x: += 50
  #defend now is {:x => 150, :y => 100}
```

If you want to extend multiple parents, it looks like this:

```yaml
socrates:
  x: 100
plato:
  y: 200
aristotle:
  extends:
    - socrates
    - plato
  x: += 50
```
If multiple keys override the same keys in a parent, the later ("younger") child takes precedent.

Note that extends keys are similar to Yaml's ["merge keys"](http://www.yaml.org/YAML_for_ruby.html#merge_key). With merge keys, you can define base styles in one entry, then include those keys elsewhere. For example:

```yaml
icon: &icon
  width: 50
  height: 50
icon_left
  <<: *icon
  x: 100
# The layout for icon_left will have the width/height from icon!
```

If you use both `extends` and Yaml merge keys, the Yaml merge keys are processed first, then extends. For clarity, however, you're probably just better off using `extends` exclusively.

### Multiple layout files

Squib also supports the combination of multiple layout files. If you provide an `Array` of files then Squib will merge them sequentially. Colliding keys will be completely re-defined by the later file. Extends is processed after _each file_. Here's a complex example:

```yaml
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
```

This can be helpful for:
  * Creating a base layout for structure, and one for color (for easier color/black-and-white switching)
  * Sharing base layouts with other designers

YAML merge keys are NOT supported across multiple files - use `extends` instead.

### Built-in Layout Files

Why mess with x-y coordinates when you're first prototyping your game?!?!? Just use a built-in layout to get your game to the table as quickly as possible.

If your layout file is not found in the current directory, Squib will search for its own set of layout files.  The latest the development version of these can be found [on GitHub](https://github.com/andymeneely/squib/tree/master/lib/squib/layouts). The `layouts_builtin.rb` sample (found [here](https://github.com/andymeneely/squib/tree/master/samples/)) demonstrate built-in layouts based on popular games (e.g. `fantasy.yml` and `economy.yml`)

Contributions in this area are particularly welcome!

### Layout Sample
This sample demonstrates many different ways of using and combining layouts. This is the `layouts.rb` sample found [here](https://github.com/andymeneely/squib/tree/master/samples/)

{include:file:samples/layouts.rb}
