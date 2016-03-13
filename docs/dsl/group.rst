group
=====

Establish a set of commands that can be enabled/disabled together to allow for customized builds. See :doc:`/build_groups` for ways to use this effectively.

Required Arguments
------------------

group
  default: ``:all``

  The name of the group. Convention is to use a Ruby symbol.


&block
  When this group is enabled (and only ``:all`` is enabled by default), then this block is executed. Otherwise, the block is ignored.


Examples
--------

Use group to organize your Squib code into build groups::

  Squib::Deck.new do
    group :pnp do
      save_pdf
    end
  end
