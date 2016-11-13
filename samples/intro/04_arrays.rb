require 'squib'

Squib::Deck.new cards: 2, layout: 'part3_layout.yml' do
  background color: '#252322'
  rect layout: 'backdrop'
  text str: ['Robot Golem', 'Ninja'],
       layout: 'title'
  svg layout: ['drone', 'human']
  svg file: ['robot-golem.svg','ninja-mask.svg'],
      layout: 'art'
  text str: ['Draw two cards',
             'Use the power of another player'],
       layout: 'power'
  save_png prefix: 'part4_', dir: '.'
end

