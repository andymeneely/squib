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

  * The :doc:`/dsl/enable_build` and :doc:`/dsl/disable_build`  DSL methods can explicitly enable/disable a group. Again, you're back to commenting out the *enable_group* call, but that's easier than remembering what lines to comment out each time.
  * When a ``Squib::Deck`` is initialized, the `environment variable <https://en.wikipedia.org/wiki/Environment_variable>`_ ``SQUIB_BUILD`` is consulted for a comma-separated string. These are converted to Ruby symbols and the corresponding groups are enabled.

Note that the environment variables are intended to change from run to run, from the command line (see above gist for examples in various OS's).

.. note::

  There should be no need to set the SQUIB_BUILD variable globally on your system.

Don't like how Windows specifies environment variables? One adaptation of this is to do the environment setting in a ``Rakefile``. Rake is the build utility that comes with Ruby, and it allows us to set different tasks exactly in this way. This Rakefile works nicely with our above code example:


.. literalinclude:: ../samples/build_groups/Rakefile
  :language: ruby
  :linenos:

Thus, you can just run this code with commands like these::

  $ rake
  $ rake pnp
  $ rake color
  $ rake test
  $ rake both
