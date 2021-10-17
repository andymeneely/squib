# typed: false
require 'squib'

Squib::Deck.new(cards: 200) do
  svg file: 'spanner.svg',
      width: 400, height: 400
  save_png prefix: 'tons_of_svg_'
end
