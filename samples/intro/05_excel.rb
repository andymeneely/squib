require 'squib'

Squib::Deck.new cards: 4, layout: 'part3_layout.yml' do
  background color: '#252322'
  rect layout: 'backdrop'
  data = xlsx file: 'data.xlsx'
  text str: data['name'], layout: 'title'
  svg layout: data['class']
  svg file: data['art'], layout: 'art'
  text str: data['power'], layout: 'power'
  save_png prefix: 'part5_', dir: '.'
  hand file: 'part5_hand.png', dir: '.', trim_radius: 38
  showcase file: 'part5_showcase.png', dir: '.'
end

