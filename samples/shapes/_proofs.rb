require 'squib'

Squib::Deck.new do
  background color: :white
  safe_zone # defaults TheGameCrafter 0.25in around the edge, rounded corners
  cut_zone  # defaults TheGameCrafter 0.125in around the edge

  text str: 'Poker card with proof lines', x: '0.25in', y: '0.25in'
  save_png prefix: 'proof_poker_'
end


Squib::Deck.new(width:'2in', height: '1in')do
  background color: :white
  safe_zone stroke_color: :purple, margin: '0.1in'
  cut_zone stroke_color: :purple, margin: '0.05in'

  text str: 'Small card with proof lines', x: '0.1in', y: '0.1in',
       font: 'Arial 10'

  save_png prefix: 'proof_tiny_'
end
