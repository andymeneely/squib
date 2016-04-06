cm
--

Given centimeters, returns the number of pixels according to the deck's DPI.

Parameters
^^^^^^^^^^

n
  the number of centimeters


Examples
^^^^^^^^

.. code-block:: ruby

  cm(1)         # 118.11px (for default Deck::dpi of 300)
  cm(2) + cm(1) # 354.33ox (for default Deck::dpi of 300)
