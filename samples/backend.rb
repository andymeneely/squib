require 'squib'

# Our SVGs are auto-saved after each step using the configuration parameters
Squib::Deck.new(config: 'backend-config.yml') do

  # These are all supported by the SVG backend
  background color: :white
  text       str: "Hello, world!", y: 500, width: 825, font: 'Sans bold 72', align: :center
  rect       x: 10, y: 10, width: 20, height: 20
  circle     x: 40, y: 40, radius: 25
  triangle   x1: 50, y1: 15, x2: 60, y2: 25, x3: 75, y3: 25
  line       x1: 100, y1: 620, x2: 720, y2: 620, stroke_width: 15.0
  svg        file: 'spanner.svg', x: 100, y: 20
  svg        file: 'glass-heart.svg', x: 100, y: 200, width: 100, height: 100, mask: :sangria
  png        file: 'shiny-purse.png', x: 250, y: 20
  png        file: 'shiny-purse.png', x: 250, y: 200, mask: :red

  # We can still rasterize whenever we want
  save_png prefix: 'backend_'

  # And our PDFs will be vectorized.
  save_pdf file: 'backend_vectorized.pdf'

  # This one is, unfortunately, not possible with svg back ends
  #   Cairo lacks a perspective transform (currently), so we have to
  #   use a striping method, which assumes raster. Fortunately, Cairo
  #   has perspective transforms on its roadmap,
  #   so perhaps this can be done someday with all vectors.
  #
  # showcase file: 'showcase.png', fill_color: 'white'

end
