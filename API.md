# Squib API

The Squib DSL is based on a collection of methods provided to the `Squib::Deck` class. The general philosophy of Squib is to specify as little as possible (i.e. great defaults )

# Squib::Deck and Squib::Card

Squib essentially has two main classes: `Deck` and `Card`. `Deck` is the front-end, and `Card` is the back-end. The contract of `Deck` is to do the various manipulations of options and then delegate the operation to `Card` to do the low-level graphical operations. 

For most users, I recommending solely using `Deck` methods. If you want to roll up your sleeves and get your hands messy, you can access the Cairo or Pango contexts the directly via the `Card` class. 

# Specifying Parameters

Squib makes extensive use of [Ruby 2.0's named parameters](http://www.ruby-doc.org/core-2.0.0/doc/syntax/calling_methods_rdoc.html#label-Keyword+Arguments). This means you can specify your parameters in any order you please. In fact, with named parameters you *must* specify which argument ties to which parameter. If you get an error like this:

```cmd
C:/Ruby200/lib/ruby/gems/2.0.0/gems/squib-0.0.2/lib/squib/api/text.rb:17:in `text': wrong number of arguments (1 for 0)
(ArgumentError)
        from hello-world.rb:5:in `block in <main>'
        from C:/Ruby200/lib/ruby/gems/2.0.0/gems/squib-0.0.2/lib/squib/deck.rb:21:in `instance_eval'
        from C:/Ruby200/lib/ruby/gems/2.0.0/gems/squib-0.0.2/lib/squib/deck.rb:21:in `initialize'
        from hello-world.rb:4:in `new'
        from hello-world.rb:4:in `<main>'
```
...then you're not specifying the parameters explicitly (e.g. the above example was with `text 'X'` instead of `text str: 'X'`)

All parameters are optional. For example `x` and `y` default to 0 (i.e. the upper-left corner of the card).

Any parameter that is specified in the command overrides any Squib defaults, `config.yml` settings, or layout rules. 

# Specifying Ranges

Most public `Deck` methods allow a range to be specified as a first parameter. This parameter is used to access an internal `Array` of `Squib::Cards`. This can be an actual Ruby range, or anything that implements `#each` (thus can be an `Enumerable`). Integers are also supported for changing one card only. Negatives work from the back of the deck. Here are some examples from `samples/ranges.rb` found [here](https://github.com/andymeneely/squib/tree/master/samples/ranges.rb)

{include:file:samples/ranges.rb}

Many more examples can be found in `ranges.rb` in the [samples](https://github.com/andymeneely/squib/tree/master/samples/) folder . In particular, take a look at some idioms that uses hashes to denote things like card "types", or future-proofing against creating and deleting cards with an ID column.

# Pixels and Other Units

By default, Squib thinks in pixels. This decision was made so that we can have pixel-perfect layouts without automatically scaling everything, even though working in units is sometimes easier. To convert, we provide the `Deck#inch` method, as shown in `samples/units.rb` found [here](https://github.com/andymeneely/squib/tree/master/samples/units.rb)

{include:file:samples/units.rb}

# Specifying Colors

Colors can be specified in a wide variety of ways, mostly in a hex-string. Take a look at the examples from `samples/colors.rb`, found [here](https://github.com/andymeneely/squib/tree/master/samples/colors.rb)

{include:file:samples/colors.rb}

Under the hood, Squib uses the `rcairo` [color parser](https://github.com/rcairo/rcairo/blob/master/lib/cairo/color.rb) to accepts a variety of color specifications, along with over [300 pre-defined constants](https://github.com/rcairo/rcairo/blob/master/lib/cairo/colors.rb). 

# Specifying Files

All files opened for reading or writing (e.g. for `png` and `xlsx`) are opened relative to the current directory. Files opened for writing (e.g. for `save_png`) will be overwritten without warning. 

# Custom Layouts

Working with x-y coordinates can be tiresome, and ideally everything in a game prototype should be data-driven. To counter this, many Squib methods allow for a `layout` to be set. In essence, layouts are a way of setting default values for `x, y, width` and `height`. 

To use a layout, set the `layout:` option on a `Deck.new` command to point to a YAML file. Any command that allows a `layout` option can be set with a Ruby symbol or String, and the command will then load the specified `x`, `y`, `width`, and `height`. The individual command can also override these options. 

Note: YAML is very finnicky about having tabs in the file. Use two spaces for indentation instead.

See the `use_layout` sample found [here](https://github.com/andymeneely/squib/tree/master/samples/)

{include:file:samples/use_layout.rb}


