require 'squib'

Squib::Deck.new(cards: 200, config: 'antialias_best.yml') do
  background color: :white
  # alphabet = 'a'.upto('z').to_a.join + ' ' + 'A'.upto('Z').to_a.join + ' '
  # text       str: alphabet * 36 , font: 'Sans Bold 18', width: 825, height: 1125, hint: :red
  0.upto(500).each do |i|
    circle radius: 50,
           x: (i % 17) * 50,
           y: (i / 17) * 50
  end
  save_png prefix: 'antialias_best_'
end
