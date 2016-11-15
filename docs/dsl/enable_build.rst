enable_build
============

Enable the given build group for the rest of the build. Thus, code within the corresponding :doc:`/dsl/build` block will be executed. See :doc:`/build_groups` for ways to use this effectively.


Required Arguments
------------------

build_group_name
  the name of the group to enable. Convention is to use a Ruby symbol.



Examples
--------

Can be used to disable a group (even if it's enabled via command line)::

  Squib::Deck.new do
    disable_build :pnp
    build :pnp do
      save_pdf
    end
  end
