Parameters are Optional
=======================

Squib is all about sane defaults and shorthand specification. Arguments to DSL methods are almost always using hashes, which look a lot like [Ruby 2.0's named parameters](http://www.ruby-doc.org/core-2.0.0/doc/syntax/calling_methods_rdoc.html#label-Keyword+Arguments). This means you can specify your parameters in any order you please. All parameters are optional.

For example `x` and `y` default to 0 (i.e. the upper-left corner of the card). Any parameter that is specified in the command overrides any Squib defaults, `config.yml` settings, or layout rules.

.. highlight:: none

Note: you MUST use named parameters rather than positional parameters. For example: ``save :png`` will lead to an error like this::

    C:/Ruby200/lib/ruby/gems/2.0.0/gems/squib-0.0.3/lib/squib/api/save.rb:12:in `save': wrong number of arguments (2 for 0..1) (ArgumentError)
        from deck.rb:22:in `block in <main>'
        from C:/Ruby200/lib/ruby/gems/2.0.0/gems/squib-0.0.3/lib/squib/deck.rb:60:in `instance_eval'
        from C:/Ruby200/lib/ruby/gems/2.0.0/gems/squib-0.0.3/lib/squib/deck.rb:60:in `initialize'
        from deck.rb:18:in `new'
        from deck.rb:18:in `<main>'

Instead, you must name the parameters: `save format: :png`

.. warning::

  If you provide an option to a DSL method that the DSL method does not recognize, Squib ignores the extraenous option without warning. For example, these two calls have identical behavior::

    save_png prefix: 'front_'
    save_png prefix: 'front_', narf: true
