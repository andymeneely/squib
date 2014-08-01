# Squib API

The Squib DSL is based on a collection of methods provided to the `Squib::Deck` class. The general philosophy of Squib is to specify as little as possible with layers of defaults, highly flexible input, and good ol' Ruby duck-typing. Ruby does a lot to make Squib useful.

# Squib::Deck and Squib::Card

Squib essentially has two main classes: `Deck` and `Card`. `Deck` is the front-end, and `Card` is the back-end. The contract of `Deck` is to do the various manipulations of options and then delegate the operation to `Card` to do the low-level graphical operations. 

For most users, I recommending solely using `Deck` methods. If you want to roll up your sleeves and get your hands messy, you can access the Cairo or Pango contexts the directly via the `Card` class. The API documentation doesn't really cover these, however, so you're on your own there.

# Specifying Parameters

Squib is all about sane defaults and shorthand specification. Arguments are almost always using hashes, which look a lot like [Ruby 2.0's named parameters](http://www.ruby-doc.org/core-2.0.0/doc/syntax/calling_methods_rdoc.html#label-Keyword+Arguments). This means you can specify your parameters in any order you please. All parameters are optional. For example `x` and `y` default to 0 (i.e. the upper-left corner of the card). Any parameter that is specified in the command overrides any Squib defaults, `config.yml` settings, or layout rules. 

# Specifying Ranges

Most public `Deck` methods allow a `range` to be specified as a first parameter. This parameter is used to access an internal `Array` of `Squib::Cards`. This can be an actual Ruby range, or anything that implements `#each` (thus can be an `Enumerable`). Integers are also supported for changing one card only. Negatives work from the back of the deck. Here are some examples from `samples/ranges.rb` found [here](https://github.com/andymeneely/squib/tree/master/samples/ranges.rb)

{include:file:samples/ranges.rb}

Note: you MUST use named parameters rather than positional parameters. For example: `save :png` will lead to an error like this:

    C:/Ruby200/lib/ruby/gems/2.0.0/gems/squib-0.0.3/lib/squib/api/save.rb:12:in `save': wrong number of arguments (2 for 0..1) (ArgumentError)
        from deck.rb:22:in `block in <main>'
        from C:/Ruby200/lib/ruby/gems/2.0.0/gems/squib-0.0.3/lib/squib/deck.rb:60:in `instance_eval'
        from C:/Ruby200/lib/ruby/gems/2.0.0/gems/squib-0.0.3/lib/squib/deck.rb:60:in `initialize'
        from deck.rb:18:in `new'
        from deck.rb:18:in `<main>'

Instead, you must name the parameters: `save format: :png`

# Pixels and Other Units

By default, Squib thinks in pixels. This decision was made so that we can have pixel-perfect layouts without automatically scaling everything, even though working in units is sometimes easier. To convert, we provide the `Deck#inch` method, as shown in `samples/units.rb` found [here](https://github.com/andymeneely/squib/tree/master/samples/units.rb)

{include:file:samples/units.rb}

# Specifying Colors

Colors can be specified in a wide variety of ways, mostly in a hex-string. Take a look at the examples from `samples/colors.rb`, found [here](https://github.com/andymeneely/squib/tree/master/samples/colors.rb)

{include:file:samples/colors.rb}

Under the hood, Squib uses the `rcairo` [color parser](https://github.com/rcairo/rcairo/blob/master/lib/cairo/color.rb) to accept a variety of color specifications, along with over [300 pre-defined constants](https://github.com/rcairo/rcairo/blob/master/lib/cairo/colors.rb). 

# Specifying Files

All files opened for reading or writing (e.g. for `png` and `xlsx`) are opened relative to the current directory. Files opened for writing (e.g. for `save_png`) will be overwritten without warning. 

# Custom Layouts

Working with x-y coordinates all the time can be tiresome, and ideally everything in a game prototype should be data-driven and easily changed. For this, many Squib methods allow for a `layout` to be set. In essence, layouts are a way of setting default values for any argument given to the command. 

To use a layout, set the `layout:` option on a `Deck.new` command to point to a YAML file. Any command that allows a `layout` option can be set with a Ruby symbol or String, and the command will then load the specified `x`, `y`, `width`, and `height`. The individual command can also override these options. 

Note: YAML is very finnicky about having tabs in the file. Use two spaces for indentation instead.

Layouts will override Squib's defaults, but are overriden by anything specified in the command itself. Thus, the order of precedence looks like this:

* Use what the command specified
* If anything was not yet specified, use what was given in a layout (if a layout was specified in the command and the file was given to the Deck)
* If still anything was not yet specified, use what was given in Squib's defaults.

Layouts also allow for a special `extends` field that will copy all of the settings from another entry. Only a single level of extends are supported currently (contact the developer if you want multiple levels). 

See the `use_layout` sample found [here](https://github.com/andymeneely/squib/tree/master/samples/)

{include:file:samples/use_layout.rb}
