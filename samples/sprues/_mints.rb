require 'squib'

# An example deck that uses "mint" sized cards (e.g. Altoids).
# These cards are pretty small but comfortably fit in a mint tin

Squib::Deck.new(cards: 21, width: '54.0mm', height: '68.0mm') do
  background color: :gray
  rect
  text str: (1..21).to_a
  save_pdf sprue: 'my_sprues/us_letter_mints.yml'
end
