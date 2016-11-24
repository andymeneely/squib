disable_build_globally
======================

Disable the given build group for all future ``Squib::Deck`` runs.

Essentially a convenience method for setting the ``SQUIB_BUILD`` environment variable. See :doc:`/build_groups` for ways to use this effectively.

This is a member of the ``Squib`` module, so you must run it like this::

  Squib.disable_build_globally :pdf

The intended purpose of this method is to be able to alter the environment from other build scripts, such as a Rakefile.

Required Arguments
------------------

build_group_name

  the name of the build group to disable. Convention is to use a Ruby symbol.


Examples
--------

Can be used to disable a group, overriding setting the environment variable at the command line::

  Squib.enable_build_globally :pdf
  Squib.disable_build_globally :pdf

  Squib::Deck.new do
    build :pdf do
      save_pdf #does not get run regardless of incoming environment
    end
  end

But gets overridden by an individual ``Squib::Deck`` programmatically enabling a build via :doc:`/dsl/enable_build`::

  Squib.enable_build_globally :pdf
  Squib.disable_build_globally :pdf

  Squib::Deck.new do
    enable_build :pdf
    build :pdf do
      save_pdf # this will be run no matter what
    end
  end
