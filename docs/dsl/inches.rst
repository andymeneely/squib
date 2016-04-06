inches
------

Given inches, returns the number of pixels according to the deck's DPI.

Parameters
^^^^^^^^^^

n
  the number of inches


Examples
^^^^^^^^

.. code-block:: ruby

  inches(2.5)                # 750 (for default Deck::dpi of 300)
  inches(2.5) + inches(0.5)  # 900 (for default Deck::dpi of 300)
