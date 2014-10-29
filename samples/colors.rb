require 'squib'

Squib::Deck.new(width: 825, height: 1125, cards: 1) do
  background color: :white

  y = 0
  text color: '#f00', str: '3-hex', x: 50, y: y+=50
  text color: '#f00', str: '3-hex (alpha)', x: 50, y: y+=50
  text color: '#ff0000', str: '6-hex', x: 50, y: y+=50
  text color: '#ff000099', str: '8-hex(alpha) *', x: 50, y: y+=50
  text color: '#ffff00000000', str: '12-hex', x: 50, y: y+=50
  text color: '#ffff000000009999', str: '12-hex (alpha)', x: 50, y: y+=50
  text color: :burnt_orange, str: 'Symbols of constants too', x: 50, y: y+=50

  save_png prefix: 'colors_'
end