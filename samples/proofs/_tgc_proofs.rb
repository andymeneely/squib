require 'squib'

# This sample uses a proof overlay from TheGameCrafter.com to check bleed
Squib::Deck.new(width: 825, height: 1125, cards: 1) do
  background color: :white
  rect x: 38, y: 38, width: 750, height: 1050, x_radius: 38, y_radius: 38
  rect x: 75, y: 75, width: 128, height: 128, x_radius: 25, y_radius: 25

  text str: 'Mastermind', x: 220, y: 78, font: 'Arial 54'
  text str: 3, x: 75, y: 85, width: 128, font: 'Arial 72', align: :center

  # TGC proof overlay (using alpha-transparency)
  png file: 'pokercard.png', x:0, y:0, alpha: 0.5

  save_png prefix: 'tgc_sample_'
end
