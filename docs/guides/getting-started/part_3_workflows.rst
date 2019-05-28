The Squib Way pt 3: Workflows
===============================

.. warning::

  Under construction

As we mentioned at the end :doc:`/guides/getting-started/part_2_iconography`, we've pretty much got most of what we need to prototype a game through completion. From here on out, the :doc:`/dsl/index` will be your best resource for getting things done.

What follows from here out is optional, but useful. As you explore Squib's features and work away at your games, you'll pick up a few tricks and conventions to follow that makes your time easier. For me personally, I've been using Squib from the beginning side-by-side with developing my own games. After 3+ years of developing games with Squib, here are some helpful ways of improving your workflow.

Improving your workflow comes down to a few principles:

  * **Automate the tedious only**. There's a balance here. What do you anticipate will change about your game as you develop it? What do you anticipate will *not* change? If you automate *everything*, you will probably spend more time on automating than on game development. If you don't automate anything, you'll be re-making every component whenever you make a game design change and Squib will be of no value to you.
  * **Focus on one thing only: visuals, game, or build**. Cognitively, you'll have an easier time when you focus on one thing and one thing only. The more loose ends you need to keep in your head, the more mistakes you'll make.

Additionally, improving your workflow can help you pivot to other tasks you might need for polishing your game later on, such as:

  * Quickly building one card at a time to reduce the time between builds
  * Auto-building your code so you can make minor adjustments and see their results
  * Handling front-to-back printing
  * Maintaining a printer-friendly, black-and-white version of your game in tandem with a color version
  * Building annotated figures for your rulebook
  * Maintaining a changelog for your playtesters who need to update their games remotely
  * Rolling back to older versions of your game

Organizing Your Project
-----------------------

Most games involve building multiple decks. Initially, you might think to put all of your Ruby code inside one file. That can work, but your development time will slow down. You'll be constantly scrolling around to find what you want instead of jumping to what you need.

Instead, I like to organize my code into separate source code files inside of a `src` directory. The :doc:`/cli/new` has an ``--advanced`` option that will create a more scalable project layout for you. Take a look at how that works. In practice, the vast majority of my own game designs follow this kind of file structure.

Retro-fitting an existing project into the advanced layout can be a little tedious, and `we would like to automate this someday <https://github.com/andymeneely/squib/issues/190>`_.


Rakefile: Your Project's Butler
-------------------------------

Programming is more than simply writing and executing one a program at a time. It's about managing lots of files and programs at once so that you can do whatever you want, whenever you want. "Building" is the software development word for this, and every programming language has some version of this tool.

In Ruby, this tool is called ``rake``. (A pun on the popular tool for C, called ``make``.) The way that ``rake`` is configured is by executing a special Ruby file called a ``Rakefile`` at the root of your repository. Use ``rake -T`` or ``rake -T [pattern]`` to quickly list available rake tasks.

Consider the following example from our built-in advanced project generator:

.. literalinclude:: ../../../lib/squib/builtin/projects/advanced/Rakefile
  :language: ruby
  :linenos:

Ideas to be written up
----------------------


* Setting up rake tasks
* Advanced project layout: splitting out decks into different files
* Testing individual files (build groups, ranges, id-lookup)
* Marketing images (using output as images, dependency in Rakefile)
* Rulebook figures (build groups, annotate after saving)
* Switch from built-in layouts to your own layout
* Launch what you need with Launchy
* Auto-building with Guard
* Maintaining color and black-and-white builds (build groups, multiple layout files). Changing build sessions within Guard
* Configuring different things for each build
* Git (save to json, tagging, rolling back, Gemfile.lock)
* Buliding on Travis and releasing on GitHub
