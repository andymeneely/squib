circle
------

Draw a partial or complete circle centered at the given coordinates

Options
^^^^^^^
.. include:: /args/expansion.rst

.. include:: /args/xy.rst

radius
  default: ``100``

  radius of the circle. Supports :doc:`/units`.

arc_start
  default: ``0``

  angle on the circle to start an arc

arc_end
  default: ``2 * Math::PI``

  angle on the circle to end an arc

arc_direction
  default: ``:clockwise``

  draw the arc clockwise or counterclockwise from arc_start to arc_end

arc_close
  default: ``false``

  draw a straight line closing the arc

.. include:: /args/draw.rst
.. include:: /args/range.rst
.. include:: /args/layout.rst

Examples
^^^^^^^^

.. literalinclude:: /../samples/shapes/_draw_shapes.rb
   :language: ruby
   :linenos:
   :caption: This snippet and others like it live `here <https://github.com/andymeneely/squib/blob/master/samples/>`_
