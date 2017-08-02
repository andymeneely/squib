Sprue Thy Sheets
================

A `sprue <https://en.wikipedia.org/wiki/Sprue_(manufacturing)>`_ is a Squib feature that customizes how cards get arranged on a sheet as part of :doc:`/dsl/save_pdf` or :doc:`/dsl/save_sheet` (PNG). This is particularly useful for:

  * Working with specific dies
  * Cutting out hex chits with fewer cuts
  * Working with quirky duplex printing
  * Printing front-to-back and having a fold in the middle
  * Printing to specific sticker sheets
  * Making an A4 version and a US Letter version for i18n

Without using a sprue, the :doc:`/dsl/save_sheet` and :doc:`/dsl/save_sheet` will simply lay out your cards one after another with the gap and margins you specify.

Like Layouts, Squib comes with a library of built-in sprues that you can use. You can make a sprue yourself, or you can generate one from the command line.

.. note::

  Would someone else find your sprue useful? Contribute one!! This is an easy way to help out the Squib community.

Make Your Own Sprue on Command Line
-----------------------------------

Squib comes with a handy little command-line interface that will generate a sprue file based on your own parameters. Of course, you can edit the sprue file once you're done to fix any quirks you like.

Here's an example run::

  $ squib make_sprue
  1. in
  2. cm
  3. mm
  What measure unit should we use? 1
  1. A4, portrait
  2. A4, landscape
  3. US letter, portrait
  4. US letter, landscape
  5. Custom size
  What paper size you are using? 3
  Sheet margins? (in) 0.125
  1. left
  2. right
  3. center
  How to align cards on sheet? [left] 3
  Card width? (in) 2.5
  Card height? (in) 3.5
  Gap between cards? (in) 0
  1. rows
  2. columns
  How to layout your cards? [rows]
  1
  1. true
  2. false
  Generate crop lines? [true]
  1
  Output to? |sprue.yml| my_sprue.yml

Of course, a Squib sprue is just a YAML file with a specific structure. Here's an example (generated from the run above)::

  ---
  sheet_width: 8.5in
  sheet_height: 11in
  card_width: 2.5in
  card_height: 3.5in
  cards:
  - x: 0.5in
    y: 0.125in
  - x: 3.0in
    y: 0.125in
  - x: 5.5in
    y: 0.125in
  - x: 0.5in
    y: 3.625in
  - x: 3.0in
    y: 3.625in
  - x: 5.5in
    y: 3.625in
  - x: 0.5in
    y: 7.125in
  - x: 3.0in
    y: 7.125in
  - x: 5.5in
    y: 7.125in
  crop_line:
    lines:
    - type: :vertical
      position: 0.5in
    - type: :vertical
      position: 3.0in
    - type: :vertical
      position: 5.5in
    - type: :vertical
      position: 8.0in
    - type: :horizontal
      position: 0.125in
    - type: :horizontal
      position: 3.625in
    - type: :horizontal
      position: 7.125in
    - type: :horizontal
      position: 10.625in


Sprue Format
------------

Here are the options for the sprue file. The entire structure of the Yaml file is a Hash

Top-Level parameters
^^^^^^^^^^^^^^^^^^^^

sheet_width
  Width of the sheet, supports :doc:`/units`.

sheet_height
  Width of the sheet, supports :doc:`/units`.

card_width
  Intended width of the card. Sprues will allow any size of card, but if the size of the incoming card does not match this size then a warning will be printed to stdout. Supports :doc:`/units`.

card_height
  Intended height of the card. Sprues will allow any size of card, but if the size of the incoming card does not match this size then a warning will be printed to stdout. Supports :doc:`/units`.

position_reference
  Default: ``topleft``

  Can be ``topleft`` or ``center``. Are the ``card`` coordinates refer to the top-left of the card, or the middle of the card?

cards
^^^^^

At the top-level should be a ``cards`` key. Within that is an array of hashes that contain the x-y coordinates to indicate the locations of the cards. The order of the coordinates indicates the order of the cards that will be laid out. When there are more cards in the deck than the number of x-y coordinates in the list, a new "page" will be made (i.e. a new page in the PDF or a new sheet for PNG sheets).

x
  Horizontal distance card from the left side of the page. Supports :doc:`/units`.

y
  Vertical distance card from the top side of the page. Supports :doc:`/units`.

rotate
  Default: ``0`` (none)

  Rotate the card around its position_reference. Allows ``clockwise``, ``counterclockwise``, or ``turnaround``, or numerical angle.

crop_line
^^^^^^^^^

Optionally, at the top-level you can specify lines to be drawn.

style
  Values: ``solid``,``dotted``,``dashed``

width
  The stroke width of the crop line. Supports :doc:`/units`.

color
  The stroke color of the crop line, using :doc:`/colors`

overlay
  Values: ``on_margin``, ``overlay_on_cards``, ``beneath_cards``.

  Specifies how the crop line is drawn: before drawing cards, after drawing cards, or only in the margins.

lines
  A hash that has the following options below

type
  Values: ``horizontal`` or ``vertical``

position
  The x-position or y-position of the crop line (depending on ``type``)


Front-to-Back Printing
----------------------

While Squib does not natively support card "fronts" and "backs" (`yet <https://github.com/andymeneely/squib/issues/93>`_), you can use sprues and the ``range`` option (see :doc:`/ranges`).

Consider this sample:

.. warning::

  To be written

Built-in Sprues
---------------

Here's a list of built-in sprues that come with Squib. You can get the original YAML files `on GitHub here <https://github.com/andymeneely/squib/tree/master/lib/squib/builtin/sprues>`_.

a4_euro_card.yml
^^^^^^^^^^^^^^^^

.. raw:: html

  <img src="sprues/sprue_a4_euro_card.yml_01.png"
    class="figure" width=550>
