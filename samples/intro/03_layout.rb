require 'squib'

Squib::Deck.new cards: 1, layout: 'part3_layout.yml' do
  background color: '#252322'
  rect layout: 'backdrop'
  text str: 'Robot Golem', layout: 'title'
  svg layout: 'drone'
  svg file: 'robot-golem.svg', layout: 'art'
  text str: 'Draw two cards.', layout: 'power'
  save_png prefix: 'part3_', dir: '.'
end

