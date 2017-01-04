Install & Update
================

Squib is a Ruby gem, and installation is handled like most gems.

Pre-requisites
--------------

  * `Ruby 2.1+ <https://www.ruby-lang.org>`_

Squib works with both x86 and x86_64 versions of Ruby.

Typical Install
---------------

Regardless of your OS, installation is

.. code-block:: none

  $ gem install squib

If you're using `Bundler <http://bundler.io>`_, add this line to your application's Gemfile::

  gem 'squib'

And then execute:

.. code-block:: none

  $ bundle install

Squib has some native dependencies, such as `Cairo <https://github.com/rcairo/rcairo>`_, `Pango <http://ruby-gnome2.sourceforge.jp/hiki.cgi?Pango%3A%3ALayout>`_, and `Nokogiri <http://nokogiri.org/>`_, which will compile upon installation - this is normal.

Updating Squib
--------------

At this time we consider Squib to be still in initial development, so we are not supporting older versions. Please upgrade your Squib as often as possible.

To keep track of when new Squib releases come out, you can watch the `BoardGameGeek thread <https://boardgamegeek.com/thread/1293453>`_ or follow the RSS feed for Squib on its `RubyGems page <https://rubygems.org/gems/squib>`_.

In RubyGems, the command looks like this:

.. code-block:: none

  $ gem up squib

As a quirk of Ruby/RubyGems, sometimes older versions of gems get caught in caches. You can see which versions of Squib are installed and clean them up, use ``gem list`` and ``gem cleanup``:

.. code-block:: none

  $ gem list squib

  *** LOCAL GEMS ***

  squib (0.9.0, 0.8.0)

  $ gem cleanup squib
  Cleaning up installed gems...
  Attempting to uninstall squib-0.8.0
  Successfully uninstalled squib-0.8.0
  Clean Up Complete

This will remove all prior versions of Squib.

As a sanity check, you can see what version of Squib you're using by referencing the ``Squib::VERSION`` constant::

  require 'squib'
  puts Squib::VERSION


OS-Specific Quirks
------------------

See the `wiki <http://github.com/andymeneely/squib/wiki>`_ for idiosyncracies about specific operating systems, dependency clashes, and other installation issues. If you've run into issues and solved them, please post your solutions for others!
