require 'squib'

# This sample demonstrates how to use the various save methods

Squib::Deck.new(width: 825, height: 1125, cards: 16) do
  background color: :gray
  rect x: 38, y: 38, width: 750, height: 1050,
       x_radius: 38, y_radius: 38, stroke: 3.0, dash: '4 4'

  text str: (1..16).to_a, x: 220, y: 78, font: 'Arial 54'

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
end
