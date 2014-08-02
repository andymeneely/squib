require 'squib'

Squib::Deck.new(width: 825, height: 1125, cards: 1) do
  background color: :white
  rect x: 38, y: 38, width: 750, height: 1050, x_radius: 38, y_radius: 38

  png file: 'shiny-purse.png', x: 620, y: 75
  svg file: 'spanner.svg', x: 620, y: 218

  # SVGs can be scaled too
  svg file: 'spanner.svg', x: 50, y: 50, width: 250, height: 250

  # We can also limit our rendering to a single object, if the SVG ID is set
  # Squib prepends a #-sign if one is not specified
  svg file: 'spanner.svg', id: '#backdrop', x: 50, y: 350, width: 75, height: 75
  svg file: 'spanner.svg', id: 'backdrop', x: 50, y: 450, width: 125, height: 125

  # WARNING! If you choose to use the SVG ID, the x-y coordinates are still
  # relative to the SVG page. See this example in an SVG editor
  svg file: 'offset.svg', id: 'thing',  x: 0, y: 0, width: 600, height: 600

  save prefix: 'load_images_', format: :png
end
