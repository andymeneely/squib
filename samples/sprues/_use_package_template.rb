require 'squib'

Squib::Deck.new(width: '63mm', height: '88mm', cards: 9) do
  text(
    str: %w[One Two Three Four Five Six Seven Eight Nine], x: '3mm', y: '3mm'
  )
  save_pdf file: 'use_package_tmpl.pdf', 
           sprue: 'a4_poker_card_9up.yml'
end
