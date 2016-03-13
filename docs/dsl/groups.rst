groups
======

Returns the set of group names that have been enabled. See :doc:`/build_groups` for ways to use this effectively.

Arguments
---------

(none)


Examples
--------

Use group to organize your Squib code into build groups::

  Squib::Deck.new do
    enable_group :pnp
    group :pnp do
      save_pdf
    end
    puts groups # outputs :all and :pnp
  end
