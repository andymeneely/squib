# typed: false
require 'squib'

Squib::Deck.new(cards: 200) do
  text str: 'tweedle beetle battle ' * 250,
       font: 'Sans bold 12', width: 825,
       ellipsize: false
  save_png prefix: 'tons_of_text_'
end
