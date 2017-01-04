require 'squib'
require 'game_icons'

Squib::Deck.new(cards: 1) do
  rect
  text str: 'foo', x: 275, y: 75, width: 500, height: 500, valign: :middle, hint: :blue
  text(str: '(heart)(heart2)',
       x: 75, y: 75, width: 500, height: 500,
       valign: :middle, hint: :red) do |embed|
    embed.svg key: '(heart)', width: 50, height: 50, data: GameIcons.get('glass-heart').string
    embed.svg key: '(heart2)', width: 50, height: 50, data: GameIcons.get('glass-heart').string
  end
  save_png prefix: 'bug_134_'
end
