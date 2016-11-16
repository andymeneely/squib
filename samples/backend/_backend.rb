require 'squib'

# Our SVGs are auto-saved after each step using the configuration parameters
Squib::Deck.new(cards: 2, config: '_backend-config.yml') do

  # These are all supported by the SVG backend
  background color: :gray
  text       str: 'Hello, world!', y: 500, width: 825, font: 'Sans bold 72', align: :center
  rect       x: 38, y: 38, width: 750, height: 1050, x_radius: 38, y_radius: 38
  circle     x: 100, y: 400, radius: 25
  triangle   x1: 100, y1: 425, x2: 125, y2: 475, x3: 75, y3: 475
  line       x1: 100, y1: 620, x2: 720, y2: 620, stroke_width: 15.0
  svg        file: 'spanner.svg', x: 100, y: 75
  png        file: 'shiny-purse.png', x: 250, y: 75 # raster can still be used too
  png        file: 'shiny-purse.png', x: 250, y: 250, mask: :red # still renders as raster
  # We can still rasterize whenever we want
  save_png prefix: 'backend_'

  showcase file: 'showcase.png', fill_color: 'white'

  # And our PDFs will be vectorized .
  save_pdf file: 'backend_vectorized.pdf', gap: 5

  # This one is a known issue. Masking an SVG onto an SVG backend is still buggy.
  # svg        file: 'glass-heart.svg', x: 100, y: 200, width: 100, height: 100, mask: :sangria
end
