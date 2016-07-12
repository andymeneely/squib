Vector vs. Raster Backends
==========================

Squib's graphics rendering engine, Cairo, has the ability to support a variety of surfaces to draw on, including both raster images stored in memory and vectors stored in SVG files. Thus, Squib supports the ability to handle both. They are options in the configuration file ``backend: memory`` or ``backend: svg`` described in :doc:`/config`.

If you use :doc:`/dsl/save_pdf` then this backend option will determine how your cards are saved too. For `memory`, the PDF will be filled with compressed raster images and be a larger file (yet it will still print at high quality... see discussion below). For SVG backends, PDFs will be smaller. If you have your deck backed by SVG, then the cards are auto-saved, so there is no ``save_svg`` in Squib. (Technically, the operations are stored and then flushed to the SVG file at the very end.)

There are trade-offs to consider here.

* Print quality is **usually higher** for raster images. This seems counterintuitive at first, but consider where Squib sits in your workflow. It's the final assembly line for your cards before they get printed. Cairo puts *a ton* of work into rendering each pixel perfectly when it works with raster images. Printers, on the other hand, don't think in vectors and will render your paths in their own memory with their own embedded libraries without putting a lot of work into antialiasing and various other graphical esoterica. You may notice that print-on-demand companies such as The Game Crafter `only accept raster file types <http://help.thegamecrafter.com/article/38-supported-file-types>`_, because they don't want their customers complaining about their printers not rendering vectors with enough care.
* Print quality is **sometimes higher** for vector images, particularly in laser printers. We have noticed this on a few printers, so it's worth testing out.
* PDFs are **smaller** for SVG back ends. If file size is a limitation for you, and it can be for some printers or internet forums, then an SVG back end for vectorized PDFs is the way to go.
* Squib is **greedy** with memory. While I've tested Squib with big decks on older computers, the `memory` backend is quite greedy with RAM. If memory is at a premium for you, switching to SVG might help.
* Squib does **not support every feature** with SVG back ends. There are some nasty corner cases here. If it doesn't, please file an issue so we can look into it. Not every feature in Cairo perfectly translates to SVG.

.. note::

  You can still load PNGs into an SVG-backed deck and load SVGs into a memory-backed deck. To me, the sweet spot is to keep all of my icons, text, and other stuff in vector form for infinite scaling and then render them all to pixels with Squib.

Fortunately, switching backends in Squib is as trivial as changing the setting in the config file (see :doc:`/config`). So go ahead and experiment with both and see what works for you.
