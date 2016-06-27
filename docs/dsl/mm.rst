mm
------

Given millimeters, returns the number of pixels according to the deck's DPI.

Parameters
^^^^^^^^^^

n
  the number of mm


Examples
^^^^^^^^

.. code-block:: ruby

  mm(1)         # 11.811px (for default Deck::dpi of 300)
  mm(2) + mm(1) # 35.433ox (for default Deck::dpi of 300)
