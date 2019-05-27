Autobuild with Guard
====================

.. warning::

  Under construction - going to fold this into the Workflow guide. For now, you can see my samples. This is mostly just a brain dump.

Throughout your prototyping process, you'll be making small adjustments and then examining the graphical output. Re-running your code can get tedious, because you're cognitively switching from one context to another, e.g. editing x-y coordinates to running your code.

Ruby has a great tool for this: `Guard <https://github.com/guard/guard>`_. With Guard, you specify one configuration file (i.e. a ``Guardfile``), and then Guard will *watch* a set of files, then execute a *task*. There are many ways of executing a task, but the cleanest way is via a ``rake`` in a ``Rakefile``.

Project layout
--------------

Here's our project layout:

.. code-block:: text

  .
  ├── config.yml
  ├── Gemfile
  ├── Guardfile
  ├── img
  │   └── robot-golem.svg
  ├── layouts
  │   ├── characters.yml
  │   └── skills.yml
  ├── Rakefile
  └── src
    ├── characters.rb
    └── skills.rb

Using Guard + Rake
------------------

Guard is a gem, just like Squib. When using Guard, I recommend also using Bundler. So your Gemfile will look like this.

.. literalinclude:: ../../samples/project/Gemfile
  :language: ruby
  :linenos:

And then your Rakefile might look something like this

.. literalinclude:: ../../samples/project/Rakefile
  :language: ruby
  :linenos:

To get our images directory set, and to turn on proress bars (which I recommend when working under Guard), you'll need a ``config.yml`` file that looks like this.

.. literalinclude:: ../../samples/project/config.yml
  :language: yaml
  :linenos:

Note that we are using ``load`` instead of ``require`` to run our code. In Ruby, ``require`` will only run our code once, because it's about loading a library. The ``load`` will run Ruby code no matter whether or not it's been loaded before. This doesn't usually matter, unless you're running under Guard.

And then our Guardfile

.. literalinclude:: ../../samples/project/Guardfile
  :language: ruby
  :linenos:


So, let's say we're working on our Character deck. To run all this we can kick off our Guard with:

.. code-block:: text

  $ bundle exec guard -g characters
  14:45:20 - INFO - Run 'gem install win32console' to use color on Windows
  14:45:21 - INFO - Starting guard-rake characters
  14:45:21 - INFO - running characters
  Loading SVG(s) <===========================================> 100% Time: 00:00:00
  Saving PNGs to _output/character__* <======================> 100% Time: 00:00:00
  ]2;[running rake task: characters] watched files: []
  [1] Characters guard(main)> ow watching at 'C:/Users/andy/code/squib/samples/project'

Guard will do an initial build, then wait for file changes to be made. From here, once we edit and save anything related to characters - any Excel file, our ``characters.rb`` file, any YML file, etc, we'll rebuild our images.

Guard can do much, much more. It opens up a debugging console based on `pry <http://pryrepl.org/>`_, which means if your code is broken you can test things out right there.

Guard also supports all kinds of notifications too. By default it tends to beep, but you can also have visual bells and other notifications.

To quit guard, type ``quit`` on their console. Or, you can do ``Ctrl+C`` to quit.

Enjoy!
