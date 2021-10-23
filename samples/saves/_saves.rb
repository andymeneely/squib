# require 'squib'
require_relative '../../lib/squib'

# This sample demonstrates how to use the various save methods
Squib::Deck.new(width: 825, height: 1125, cards: 16) do
  background color: :gray
  rect x: 38, y: 38, width: 750, height: 1050,
       x_radius: 38, y_radius: 38, stroke_width: 2.0, dash: '4 4'

  text str: (1..16).to_a, x: 220, y: 78, font: 'Arial 18'

  # Here's what a regular save_png looks like for just the first card
  save_png range: 0, prefix: 'save_png_'

  # save_png supports trim and trim_radius
  save_png trim: 30, trim_radius: 38,
           range: 0, prefix: 'save_png_trimmed_'

  # Place on multiple pages over the PDF, with bleed beeing trimmed off
  save_pdf file: 'save-pdf.pdf', margin: 75, gap: 5, trim: 37

  # PDFs also support arbitrary paper sizes, in pixels or any other supported units
  save_pdf file: 'save-pdf-small.pdf',
           width: '7in', height: '5in',
           range: 0..1

  # Note that our PNGs still are not trimmed even though the pdf ones were
  save_png range: 1, prefix: 'saves_notrim_'

  # We can also save our PNGs into a single sheet,
  #  rows are calculated based on cols and number of cards
  save_sheet prefix: 'save_single_sheet_',
             columns: 2, margin: 75, gap: 5, trim: 37

  # Or multiple sheets if rows are also specified
  save_sheet prefix: 'save_sheet_',
             columns: 4, rows: 2,
             margin: 75, gap: 5, trim: 37

  # Sheets support ranges too
  save_sheet prefix: 'save_sheet_range_',
             range: 0..5,
             columns: 2, rows: 2,
             margin: 75, gap: 5, trim: 37

  # Sheets can arrange left-to-right and right-to-left
  save_sheet prefix: 'save_sheet_rtl_',
             suffix: '_with_suffix',
             range: 0..1, rtl: true,
             columns: 2, rows: 1,
             margin: 75, gap: 5, trim: 37
end

Squib::Deck.new(width: 100, height: 100, cards: 3) do
  background color: :grey
  text str: 'Hi', font: 'Arial 18'

  # Test bug 332.
  # When we only have 3 cards but want a 2x4 grid with lots of empty spaces.
  # Buggy behavior was to revert to 1 row and not respect the rows arg.
  save_sheet prefix: 'save_sheet_bug332_', rows: 2, columns: 4
end

# Allow rotating
Squib::Deck.new(width: 100, height: 50, cards: 8) do
  background color: :white
  rect x: 10, y: 10, width: 80, height: 30
  rect x: 5, y: 5, width: 90, height: 40, stroke_width: 5, stroke_color: :blue
  text y: 2, str: 0..7, font: 'Open Sans Bold 8', align: :center, width: 100
  save_sheet prefix: 'save_sheet_unrotated_', rows: 2, columns: 3
  save_sheet prefix: 'save_sheet_custom_rotate_', rows: 2, columns: 3, rotate: [:clockwise, :counterclockwise] * 4
  save_sheet prefix: 'save_sheet_rotated_', rows: 2, columns: 3, rotate: true
  save_sheet prefix: 'save_sheet_rotated_trimmed_', rows: 2, columns: 3, rotate: true, trim: 5
  save_sheet prefix: 'save_sheet_rotated_trimmed_rtl_', rows: 2, columns: 3, rotate: true, trim: 5, rtl: true
end
