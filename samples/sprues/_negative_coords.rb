require_relative '../../lib/squib'

Squib::Deck.new(width: 100, height: 100, cards: 3) do 
  background color: :grey
  text str: 'Hello', font: 'Sans Bold 10'
  save_sheet sprue: 'my_sprues/negatives.yml', prefix: 'sprue_negatives_'
end