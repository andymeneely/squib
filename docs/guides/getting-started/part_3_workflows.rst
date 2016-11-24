The Squib Way pt 3: Workflows
===============================

.. warning::

  Under construction

As we mentioned at the end :doc:`/guides/getting-started/part_2_iconography`, we've pretty much got most of what we need to prototype a game through completion. From here on out, the :doc:`/dsl/index` will be your best resource for getting things done. Everything from here one out is optional, but useful.

But, as you explore Squib's features and work away at your games, you'll pick up a few tricks and conventions to follow that makes your time easier. After years of developing games with Squib, here are some helpful ways of improving your workflow.

Improving your workflow comes down to a few principles:

  * **Automate what will be tedious**. There's a balance here. What do you anticipate will change about your game as you develop it? What do you anticipate will *not* change? If you automate *everything*, you will probably spend more time on automating than game development. If you don't automate anything, you'll be re-making every component whenever you make a game design change.
  * **Focus on one thing only: visual, game, or build**. Cognitively, you'll have an easier time when you focus on one thing and one thing only. The more loose ends you need to keep in your head, the more mistakes you'll make.

Additionally, improving your workflow can help you pivot to other tasks you might need for polishing your game later on, such as:

  * Quickly building one card at a time to reduce the time between builds
  * Maintaining a printer-friendly, black-and-white version of your game in tandem with a color version
  * Building annotated figures for your rulebook
  * Rolling back to older versions of your game

Organizing Your Project
-----------------------

Most games involve build multiple decks. Initially, you might think to put all of your Ruby code inside one file. That can work, but it gets slow and cumbersome. Instead, I like to organize my code into separate source code files inside of a `src` directory.

Keeping your artwork in its own folder will also make it easier for you to find what you need later on. Also, using `img_dir` parameter in the `config.yml` will let you switch the entire image directory over in one

Using a Rakefile
----------------



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
