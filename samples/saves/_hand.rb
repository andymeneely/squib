require 'squib'

Squib::Deck.new(cards: 8, layout: 'playing-card.yml') do
  background color: :cyan
  rect x: 37, y: 37, width: 750, height: 1050, fill_color: :black, radius: 25
  rect x: 75, y: 75, width: 675, height: 975, fill_color: :white, radius: 20
  text str: ('A'..'Z').to_a, layout: :bonus_ul, font: 'Sans bold 100'

  # Defaults are sensible
  hand # saves to _output/hand.png

  # Here's a prettier version:
  #  - Each card is trimmed with rounded corners
  #  - Zero radius means cards rotate about the bottom of the card
  #  - Cards are shown in reverse order
  hand trim: 37.5, trim_radius: 25,
       radius: 0,
       range: 7.downto(0),
       file: 'hand_pretty.png'

  # Tip: you can have the top card be on the left by reversing the range
  #  angle_range: (Math::PI / 4)..(Math::PI / -4)
end
