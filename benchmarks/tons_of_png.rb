# typed: false
require 'squib'

Squib::Deck.new(cards: 200) do
  png file: 'shiny-purse.png'
  save_png prefix: 'tons_of_png_'
end
