require 'squib'

Squib::Deck.new(cards: 200, config: 'backend-svg.yml') do
  background color: :white
  text       str: "Hello, world!", y: 500, width: 825, font: 'Sans bold 72', align: :center
  rect       x: 10, y: 10, width: 20, height: 20
  circle     x: 40, y: 40, radius: 25
  triangle   x1: 50, y1: 15, x2: 60, y2: 25, x3: 75, y3: 25
  line       x1: 100, y1: 620, x2: 720, y2: 620, stroke_width: 15.0
  svg        file: 'spanner.svg', x: 100, y: 20
  png        file: 'shiny-purse.png', x: 250, y: 20
  save_png   prefix: 'rasterized_'
  save_pdf   file: 'backend.pdf'
end