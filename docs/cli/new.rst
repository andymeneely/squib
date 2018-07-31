squib new
---------

Generate a basic Squib project layout.

While Squib is just a Ruby library that can be used in all kinds of ways, there a bunch of tried-and-true techniques on how to use it. To make this process easier, we provide some built-in project starter kits.


Basic
~~~~~

The default run will generate a "basic" layout::

  $ squib new arctic-lemming

This kit includes the following:

  * ``deck.rb`` is your main source code file
  * ``config.yml`` is the default config file for all runs of Squib
  * ``layout.yml`` is a basic layout file
  * ``Rakefile`` has a basic ``rake`` task (if you're familiar with that - it's not necessary).
  * **Git files**, such as ``.gitignore``, and ``gitkeep.txt``. These are helpful because *every* coding project should use version control.
  * **Markdown files**, e.g. ``IDEAS.md``, ``RULES.md``, ``PLAYTESTING.md``, and ``ABOUT.md``, to write notes in and organize your ideas.

You can see `the basic files here on GitHub <https://github.com/andymeneely/squib/tree/master/lib/squib/builtin/projects/basic>`_

``--advanced``
~~~~~~~~~~~~~~

If you run with the ``--advanced`` flag, you get a lot more stuff::

  $ squib new --advanced arctic-lemming

In particular, the ``--advanced`` run will all run through Ruby's ``rake`` command. You will no longer be able to run your ruby scripts directly with ``ruby deck.rb``, instead you'll need to do ``rake``. See :doc:`/guides/getting-started/part_3_workflows` for a walkthrough.

Addtionally, everything else is broken out into directories.

   * We assume you will have a LOT of images, so there's a separate image directory configured
   * A default Excel sheet is included, in its own data
   * The ``Rakefile`` is much more advanced, taking advantage of build groups and various other things
   * Assume one layout file per deck
   * Separate the game documents (e.g. ``RULES.md``) from the project documents (e.g. ``IDEAS.md``)
   * We also include a ``Guardfile`` so you can auto-build your code as you are writing it.
   * We include a version file so you can track the version of your code and print that on all of your cards. It's a good idea to have this in its own file.
   * The default ``deck.rb`` demonstrates some more advanced features of Squib

You can see the advanced project kit files here `on GitHub <https://github.com/andymeneely/squib/tree/master/lib/squib/builtin/projects/advanced>`_
