require 'squib'

Squib::Deck.new(width: '65.8mm', height: '76mm', cards: 9) do
  polygon(
    x: '32.9mm', y: '38mm', n: 6, radius: '38mm', angle: 1.571,
    stroke_color: :black, stroke_width: '0.014in', fill_color: :pink
  )
  text(
    str: %w[One Two Three Four Five Six Seven Eight Nine],
    x: '22mm', y: '35mm', width: '21.8mm', height: '6mm',
    align: :center, valign: :middle
  )
  save_pdf file: 'hex_tiles.pdf',
           sprue: 'my_sprues/hex_tiles.yml'
end
