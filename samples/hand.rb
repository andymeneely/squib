require 'squib'

# Built-in layouts are easy to use and extend
Squib::Deck.new(cards: 8, layout: 'playing-card.yml') do
  # background color: :white
  # rect x: 37, y: 37, width: 750, height: 1050, fill_color: :black
  # rect x: 75, y: 75, width: 675, height: 975, fill_color: :white
  # text str: ('A'..'H').to_a, layout: :bonus_ul, font: 'Sans bold 100'
  # def helper(a)
  #   puts a
  # end
  # helper('abc')
  # helper('def')
  # # hand range: :all,
  # #      center_x: :auto, center_y: :auto,
  # #      angle_start: 0, angle_end: Math::PI,
  # #      width: :auto, height: :auto,
  # save_png prefix: 'hand_'
end

