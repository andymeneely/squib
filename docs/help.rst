Get Help and Give Help
======================

Show Your Pride
---------------

.. raw:: html

  On BoardGameGeek.com? Show your Squib pride by <a href="https://boardgamegeek.com/microbadge/37841">getting the microbadge <img src="https://cdn.rawgit.com/andymeneely/squib/gh-pages/images/microbadge.png" style="margin-bottom: 0px"></a> and <a href="https://boardgamegeek.com/guilds/2601">joining our guild!</a>

We would also love to hear about the games you make with Squib!

Get Help
--------

Squib is powerful and customizable, which means it can get complicated pretty quickly. Don't settle for being stuck.

Here's an ordered list of how to find help:

1. Go through this documentation
2. Go through `the wiki <https://github.com/andymeneely/squib/wiki>`_
3. Go through `the samples <https://github.com/andymeneely/squib/tree/master/samples>`_
4. Google it - people have asked lots of questions about Squib already in many forums.
5. Ask on Stackoverflow `using the tags "ruby" and "squib" <http://stackoverflow.com/questions/ask?tags=ruby squib>`_. You will get answers quickly from Ruby programmers it's and a great way for us to archive questions for future Squibbers.
6. Our `thread on BoardGameGeek <http://boardgamegeek.com/thread/1293453>`_ or `our guild <https://boardgamegeek.com/guild/2601>`_ is quite active and informal (if a bit unstructured).

If you email me directly I'll probably ask you to post your question publicly so we can document answers for future Googling Squibbers.

Please use GitHub issues for bugs and feature requests.

Help by Troubleshooting
-----------------------

One of the best ways you can help the Squib community is to be active on the above forums. Help people out. Answer questions. Share your code. Most of those forums have a "subscribe" feature.

You can also watch the project on GitHub, which means you get notified when new bugs and features are entered. Try reproducing code on your own machine to confirm a bug. Help write minimal test cases. Suggest workarounds.

Help by Beta Testing
--------------------

Squib is a small operation. And programming is hard. So we need testers! In particular, I could use help from people to do the following:

  * Test out new features as I write them
  * Watch for regression bugs by running their current projects on new Squib code, checking for compatibility issues.

Want to join the mailing list and get notifications? https://groups.google.com/forum/#!forum/squib-testers

There's no time commitment expectation associated with signing up. Any help you can give is appreciated!

Beta: Using Pre-Builds
^^^^^^^^^^^^^^^^^^^^^^

The preferred way of doing beta testing is by to get Squib directly from my GitHub repository. Bundler makes this easy.

If you are just starting out you'll need to install bundler:

.. code-block:: none

  $ gem install bundler

Then, in the root of your Squib project, create a file called `Gemfile` (capitalization counts). Put this in it::

  source 'https://rubygems.org'

  gem 'squib', git: 'git://github.com/andymeneely/squib', branch: 'master'

Then run:

.. code-block:: none

  $ bundle install

Your output will look something like this:

.. code-block:: none

  Fetching git://github.com/andymeneely/squib
  Fetching gem metadata from https://rubygems.org/.........
  Fetching version metadata from https://rubygems.org/...
  Fetching dependency metadata from https://rubygems.org/..
  Resolving dependencies...
  Using pkg-config 1.1.6
  Using cairo 1.14.3
  Using glib2 3.0.7
  Using gdk_pixbuf2 3.0.7
  Using mercenary 0.3.5
  Using mini_portile2 2.0.0
  Using nokogiri 1.6.7
  Using pango 3.0.7
  Using rubyzip 1.1.7
  Using roo 2.3.0
  Using rsvg2 3.0.7
  Using ruby-progressbar 1.7.5
  Using squib 0.9.0b from git://github.com/andymeneely/squib (at master)
  Using bundler 1.10.6
  Bundle complete! 1 Gemfile dependency, 14 gems now installed.
  Use `bundle show [gemname]` to see where a bundled gem is installed.

To double-check that you're using the test version of Squib, puts this in your code::

  require 'squib'
  puts Squib::VERSION # prints the Squib version to the console when you run this code

  # Rest of your Squib code...

When you run your code, say ``deck.rb``, you'll need to put ``bundle exec`` in front of it. Otherwise Ruby will just go with full releases (e.g. ``0.8`` instead of pre-releases, e.g. ``0.9a``). That would look like this:

.. code-block:: none

  $ bundle exec ruby deck.rb

If you need to know the exact commit of the build, you can see that commit hash in the generated ``Gemfile.lock``. That ``revision`` field will tell you the *exact* version you're using, which can be helpful for debugging. That will look something like this::

  remote: git://github.com/andymeneely/squib
    revision: 440a8628ed83b24987b9f6af66ad9a6e6032e781
    branch: master

To update to the latest from the repository, run ``bundle up``.

To remove Squib versions, run ``gem cleanup squib``. This will also remove old Squib releases.

Beta: About versions
^^^^^^^^^^^^^^^^^^^^

  * When the version ends in "a" (e.g. ``v0.9a``), then the build is "alpha". I could be putting in new code all the time without bumping the version. I try to keep things as stable after every commit, but this is considered the least stable code. (Testing still appreciated here, though.) This is also tracked by my ``dev`` branch.
  * For versions ending in "b" (e.g. ``v0.9b``), then the build is in "beta". Features are frozen until release, and we're just looking for bug fixes.  This tends to be tracked by the ``master`` branch in my repository.
  * I follow the `Semantic Versioning <http://semver.org>`_ as best I can

Beta: About Bundler+RubyGems
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The Gemfile is a configuration file (technically it's a Ruby DSL) for a widely-used library in the Ruby community called Bundler. Bundler is a way of managing multiple RubyGems at once, and specifying exactly what you want.

Bundler is different from RubyGems. Technically, you CAN use RubyGems without Bundler: just ``gem install`` what you need and your ``require`` statements will work. BUT Bundler helps you specify versions with the Gemfile, and where to get your gems. If you're switching between different versions of gems (like with being tester!), then Bundler is the way to go. The Bundler website is here: http://bundler.io/.

By convention, your ``Gemfile`` should be in the root directory of your project. If you did ``squib new``, there will be one created by default. Normally, a Squib project Gemfile will look `like this <https://github.com/andymeneely/squib/blob/master/lib/squib/project_template/Gemfile>`_. That configuration just pulls the Squib from RubyGems.

But, as a tester, you'll want to have Bundler install Squib from my repository. That would look like this: https://github.com/andymeneely/project-spider-monkey/blob/master/Gemfile. (Just line 4 - ignore the other stuff.) I tend to work with two main branches - dev and master. Master is more stable, dev is more bleeding edge. Problems in the master branch will be a surprise to me, problems in the dev branch probably won't surprise me.

After changing your Gemfile, you'll need to run ``bundle install``. That will generate a ``Gemfile.lock`` file - that's Bundler's way of saying exactly what it's planning on using. You don't modify the Gemfile.lock, but you can look at it to see what version of Squib it's locked onto.



Help by Fixing Bugs
-------------------

A great way to make yourself known in the community is to go over `our backlog <https://github.com/andymeneely/squib/issues>`_ and work on fixing bugs. Even suggestions on troubleshooting what's going on (e.g. trying it out on different OS versions) can be a big help.

Help by Contributing Code
-------------------------

Our biggest needs are in community support. But, if you happen to have some code to contribute,  follow this process:

1. Fork the git repository ( https://github.com/[my-github-username]/squib/fork )
2. Create your feature branch (``git checkout -b my-new-feature``)
3. Commit your changes (``git commit -am 'Add some feature'``)
4. Push to the branch (``git push origin my-new-feature``)
5. Create a new Pull Request

Be sure to write tests and samples for new features.

Be sure to run the unit tests and packaging with just ``rake``. Also, you can check that the samples render properly with ``rake sanity``.
