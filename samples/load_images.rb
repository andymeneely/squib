require 'squib'

Squib::Deck.new(width: 825, height: 1125, cards: 1) do
  background color: :white
  rect x: 38, y: 38, width: 750, height: 1050, x_radius: 38, y_radius: 38

  png file: 'shiny-purse.png', x: 620, y: 75
  svg file: 'spanner.svg', x: 620, y: 218

  # SVGs can be scaled too
  svg file: 'spanner.svg', x: 50, y: 50, width: 250, height: 250

  save prefix: 'load_images_', format: :png
end
