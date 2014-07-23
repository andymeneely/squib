require 'squib'

Squib::Deck.new(width: 825, height: 1125, cards: 3) do
  background color: :white

  bleed = inches(0.125)
  cut_width = inches(2.5)
  cut_height = inches(3.5)
  rect x: bleed, y: bleed, width: cut_width, height: cut_height, radius: 25

  save prefix: 'units_', format: :png
end
