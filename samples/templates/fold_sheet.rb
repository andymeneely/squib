require 'squib'

Squib::Deck.new(width: '63mm', height: '88mm', cards: 8) do
  rect fill_color: :gray
  text(
    str: %w[Front_1 Front_2 Front_3 Front_4 Back_1 Back_2 Back_3 Back_4],
    x: '3mm', y: '3mm'
  )
  save_pdf file: 'fold_sheet.pdf', template_file: 'templates/fold_sheet.yml'
end
