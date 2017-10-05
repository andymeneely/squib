require 'squib'

Squib::Deck.new(cards: 3, layout: 'layout.yml') do
  text str: 'Hello, World!'
  save format: :png
end
