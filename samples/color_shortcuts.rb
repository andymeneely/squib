require 'squib'

Squib::Deck.new do
  circle color: 'black', fill_color: 'black'
  save_png prefix: 'color_shortcuts_'
end
