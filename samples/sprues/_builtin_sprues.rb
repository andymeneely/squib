require 'squib'

Squib::Deck.new(cards: 8) do
  background color: :white
  rect stroke_width: 5, stroke_dash: '7 7'
  text str: %w(First Second Third Fourth Fifth Sixth Seventh Eighth),
       font: 'Sans 96', align: :center, valign: :middle,
       height: :deck, width: :deck

  %w(
    a4_euro_card.yml
    a4_poker_card_8up.yml
    a4_poker_card_9up.yml
    a4_usa_card.yml
  ).each do |builtin|
    save_sheet sprue: builtin, prefix: "sprue_#{builtin}_", dir: '.'
  end
end
