#!/usr/bin/env ruby
require 'squib'

Squib::Deck.new(width: 825, height: 1125, cards: 16) do
  background color: :gray
  rect x: 38, y: 38, width: 750, height: 1050, x_radius: 38, y_radius: 38

  text str: (1..16).to_a, x: 220, y: 78, font: 'Arial 54'

  save_pdf file: 'sample-save-pdf.pdf', margin: 75, gap: 5, trim: 37

  #Note that our PNGs still are not trimmed even though the pdf ones are
  save_png range: 1, prefix: 'save_pdf_'
end
