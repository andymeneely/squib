require 'squib'

Squib::Deck.new(width: '1.5in', height: '1.5in') do
  background color: :white

  # Squib has a custom unit, called "cell"
  # A "cell" unit defaults to 37.5px, which at 300dpi is 1/8in or 3.175mm
  # This is a very common multiple for layouts.
  # This helps us lay things out in grids without doing much math in our heads
  # Here's an example... with grid!
  grid width: '1 cell', height: '1 cell'

  # Plurals are fine or just 'c' as a unit is fine
  # Whitespace is pretty lenient too.
  rect fill_color: :blue,
       x: '1 cell', y: '2 cells',
       width: '1c', height: '1cell  '

  # Technically, the "cell" is actually a "unit", so you can even combine
  # with xywh shorhands!!
  rect fill_color: :red,
       x: 'middle + 0.5c', y: 'deck - 1.5c',
       width: '1c', height: '1c'

  # And, unlike xywh shorthands, this applies basically everywhere we support
  # unit conversion.
  circle fill_color: :green,
         x: '3c', y: '2c', radius: '1c'
  # Decimals are fine too
  circle fill_color: :green,
         x: '5c', y: '2c', radius: '0.5c'
  # Even dashes!
  circle fill_color: '#0000', stroke_color: :purple,
         x: '1c', y: '4c', radius: '0.5c', dash: '0.25c 0.25c'

  # We can also do stuff in layout. Check out the yml file...
  #  (even cleaner in Yaml since we don't need quotes!)
  use_layout file: 'cells.yml'
  rect layout: :example
  rect layout: :extends_example

  save_png prefix: 'cells_'
end


# You can customize this with the cell_px configuration option
Squib::Deck.new(width: 100, height: 100, config: 'cell_config.yml') do
  background color: :white
  rect x: '1c', y: '1c', width: '1c', height: '1c', fill_color: :purple
  save_png prefix: 'custom_cell_'
end