require 'squib'

Squib::Deck.new(cards: 3) do 
  text str: "Hello, World!"
  save format: :png
end