require 'squib'

# Note that this sample has no bleed - you might want to have bleed
# but tighter than usual: 0.1 instead of 0.125in since this sprue is
# crowded horizontally on US letter
Squib::Deck.new(width: '2.5in', height: '3.5in', cards: 8) do
  background color: :white
  rect stroke_width: 5, stroke_color: :red
  # Note that we are interleaving strings
  # This could be used as a secondary Squib script that loads
  # Squib-generated individual images
  strings = [
    "Front 1",
    "Back 1",
    "Front 2",
    "Back 2",
    "Front 3",
    "Back 3",
    "Front 4",
    "Back 4",
  ]

  text str: strings,font: 'Sans 32', align: :center, valign: :middle,
       height: :deck, width: :deck
  save_sheet prefix: 'foldable_',
             sprue: 'letter_poker_foldable_8up.yml'
end
