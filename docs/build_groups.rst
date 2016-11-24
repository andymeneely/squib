Group Your Builds
=================

Often in the prototyping process you'll find yourself cycling between running your overall build and building a single card. You'll probably be commenting out code in the process.

And even after your code is stable, you'll probably want to build your deck multiple ways: maybe a printer-friendly black-and-white version for print-and-play and then a full color version.

Squib's Build Groups help you with these situations. By grouping your Squib code into different groups, you can run parts of it at a time without having to go back and commenting out code.

Here's a basic example:

.. literalinclude:: ../samples/build_groups/build_groups.rb
  :language: ruby
  :linenos:

Only one group is enabled by default: ``:all``. All other groups are disabled by default. To see which groups are enabled currently, the :doc:`/dsl/build_groups` returns the set.

Groups can be enabled and disabled in several ways:

  * The :doc:`/dsl/enable_build` and :doc:`/dsl/disable_build`  DSL methods within a given ``Squib::Deck`` can explicitly enable/disable a group. Again, you're back to commenting out the *enable_group* call, but that's easier than remembering what lines to comment out each time.
  * When a ``Squib::Deck`` is initialized, the `environment variable <https://en.wikipedia.org/wiki/Environment_variable>`_ ``SQUIB_BUILD`` is consulted for a comma-separated string. These are converted to Ruby symbols and the corresponding groups are enabled. This is handy for enabling builds on the command line (e.g. turn on color, work in that for a while, then turn it off)
  * Furthermore, you can use :doc:`Squib.enable_build_globally </dsl/enable_build_globally>` and :doc:`Squib.disable_build_globally </dsl/disable_build_globally>` to manipulate ``SQUIB_BUILD`` environment variable programmatically (e.g. from a Rakefile, inside a `Guard <https://github.com/guard/guard>`_ session, or other build script).

The :doc:`/guides/getting-started/part_3_workflows` tutorial covers how to work these features into your workflow.

.. note::

  There should be no need to set the SQUIB_BUILD variable globally on your system (e.g. at boot). The intent is to set SQUIB_BUILD as part of your session.

One adaptation of this is to do the environment setting in a ``Rakefile``. `Rake <https://ruby.github.io/rake/>`_ is the build utility that comes with Ruby, and it allows us to set different tasks exactly in this way. This Rakefile works nicely with our above code example:


.. literalinclude:: ../samples/build_groups/Rakefile
  :language: ruby
  :linenos:

Thus, you can just run this code on the command line like these::

  $ rake
  $ rake pnp
  $ rake color
  $ rake test
  $ rake both
