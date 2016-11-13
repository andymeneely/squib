require 'squib'

Squib::Deck.new cards: 1 do
  background color: '#252322'
  rect fill_color: '#0B3736',
       x: 38, y: 38, width: 750, height: 1050, radius: 38
  text str: 'Robot Golem', font: 'True Crimes, Sans 72',
       align: :center, x: 75, width: :deck, color: '#DFDFE1', y: 90
  svg file: 'auto-repair.svg', x: 75, y: 75, width: 100, height: :scale
  svg file: 'robot-golem.svg', x: 75, y: 300, width: 675, height: :scale
  text str: 'Draw two cards', font: 'Serif 36',
       align: :center, width: :deck, color: '#DFDFE1', y: 1000
  save_png prefix: 'part2_', dir: '.'
end

