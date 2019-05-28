Always Have Bleed
=================

Summary
^^^^^^^

* Always plan to have a printing bleed around the edge of your cards. 1/8 inches is standard.
* Have a safe zone too
* Layouts make this easy (see the built-in layouts)
* Can use png overlays from templates to make sure it fits
* Trim option is what is used everywhere in Squib
* Trim_radius also lets you show your cards off like how they'll really look

An example is also shown in :doc:`/guides/getting-started/part_1_zero_to_game`.

What is a bleed?
^^^^^^^^^^^^^^^^

As mentioned in the summary above, we mostly add a cut and a safe rectangle on cards for guides based on the poker card templates like the one from `TheGameCrafter.com <http://www.thegamecrafter.com>`_ ( `PDF template <https://s3.amazonaws.com/www.thegamecrafter.com/templates/poker-card.ai>`_). See below section :ref:`templates` for more templates as illustration and help. This is important to do as early as possible because this affects the whole layout. In most print-on-demand templates, we have a 1/8-inch border that is larger than what is to be used, and will be cut down (called a *bleed*). Rather than have to change all our coordinates later, let's build that right into our initial prototype in the first stage. Squib can trim around these bleeds for things like :doc:`/dsl/showcase`, :doc:`/dsl/hand`, :doc:`/dsl/save_sheet`, :doc:`/dsl/save_png`, and :doc:`/dsl/save_pdf`.

See for more details about a discussion whether or not to use a bleed on `boardgamegeek.com <https://boardgamegeek.com/thread/1038946/cards-or-without-bleed>`_ and `specifically one of the comments <https://boardgamegeek.com/article/13410490#13410490>`_.

* **Crop** - the area which is going to be cut out to meet the final size requirements.
* **Bleed** - an extra printed area outside of the crop, to ensure that the printing runs all the way to the edge of the printed, cut piece.

Usage
^^^^^

We can add such cut and safe zones with the available DSL methods :doc:`/dsl/cut_zone` and :doc:`dsl/safe_zone` or by using a layout which specifies the cut and safe zone which are later used with the layout option for the :doc:`/dsl/rect` method.

Layout::

  cut:
    x: 0.125in
    y: 0.125in
    width: 2.5in
    height: 3.5in
    radius: 0

In your Squib script::

    rect layout: 'cut', stroke_color: :white

Or by using the DSL methods::

  cut_zone radius: 0,  stroke_color: :white
  safe_zone radius: 0, stroke_color: :red

Afterwards, you can save the whole card including the bleed or without the bleed by using the mentioned trim method without affecting all other parts of your layout::

  save_png ... trim: '0.125in' ...
  save_pdf sprue: 'drivethrucards_1up.yml', trim: '0.125in'

Example
^^^^^^^

In this example we see the cut zone and the safe zone inside the bleed.

.. raw:: html

  <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
  <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/gist-embed/2.4/gist-embed.min.js"></script>
  <code data-gist-id="d2bb2eb028b27cf1dace"
        data-gist-file="02_onecard.rb"></code>
  <code data-gist-id="d2bb2eb028b27cf1dace"
        data-gist-file="02_onecard_rb.png"
        class=code_img
        ></code>

Templates
^^^^^^^^^

See the following templates and card descriptions for more information about the above mentioned zone types. The different layouts and sizes are described and illustrated in the linked PDFs.

* https://s3.amazonaws.com/www.thegamecrafter.com/templates/poker-card.ai
* https://www.makeplayingcards.com/dl/templates/playingcard/American-poker-size.pdf
* http://www.drivethrucards.com/images/site_resources/Specifications%20for%20Printing%20Poker%20Cards%20Rev.pdf
* https://onebookshelfpublisherservice.zendesk.com/attachments/token/KDYaJUheJHn67QaJSOIe0B2DQ/?name=DTCards-US+Poker.pdf
