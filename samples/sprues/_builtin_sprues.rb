require 'squib'

Squib::Deck.new(width: '50mm', height: '70mm', cards: 9) do
  background color: :white
  rect stroke_width: 5, stroke_color: :red
  text str: (0..9).map{ |i| "Card! #{i}\n50x77mm" },
       font: 'Sans 32', align: :center, valign: :middle,
       height: :deck, width: :deck

  %w(
    a4_poker_card_8up.yml
    a4_euro_card.yml
    a4_poker_card_9up.yml
    a4_usa_card.yml
    letter_poker_card_9up.yml
    printplaygames_18up.yml
    drivethrucards_1up.yml
  ).each do |builtin|
    save_sheet sprue: builtin, prefix: "sprue_#{builtin}_"
  end
end
