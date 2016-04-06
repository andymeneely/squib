Unit Conversion
===============

By default, Squib thinks in pixels. This decision was made so that we can have pixel-perfect layouts without automatically scaling everything, even though working in units is sometimes easier. We provide some conversion methods, including looking for strings that end in "in" and "cm" and computing based on the current DPI. The dpi is set on `Squib::Deck.new` (not `config.yml`).

Example is in `samples/units.rb` found [here](https://github.com/andymeneely/squib/tree/master/samples/units.rb)
