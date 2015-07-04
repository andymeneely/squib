require 'squib'

Squib::Deck.new(cards: 2) do
  text str: %w(Hello World!)
  save_png
end
