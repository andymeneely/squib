#!/usr/bin/env ruby
require 'squib'

Squib::Deck.new(width: 825, height: 1125, cards: 16) do
  background color: :gray
  rect x: 38, y: 38, width: 750, height: 1050, x_radius: 38, y_radius: 38

  text str: (1..16).to_a, x: 220, y: 78, font: 'Arial 54'

  save_pdf file: "sample.pdf", margin: 50, gap: 5, trim: 38
end

puts "Done!"