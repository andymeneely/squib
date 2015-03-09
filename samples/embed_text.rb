require 'squib'

Squib::Deck.new do
  rect x: 0, y: 0, width: 825, height: 1125
  rect x: 0, y: 0, width: 180, height: 180, stroke_color: :red

  # embed_text = 'Take 1:tool:and gain 2 :health:. Take 2 :tool: if level 2'
  embed_text = '1 :tool: 2 :health:'
  text(str: embed_text, font: 'Sans 18',
       x: 0, y: 0, width: 180,
       align: :center, ellipsize: false, justify: false) do |embed|
    embed.svg key: ':tool:',   width: 28, height: 28, file: 'spanner.svg'
    embed.svg key: ':health:', width: 28, height: 28, file: 'glass-heart.svg'
  end

  save_png prefix: 'embed_'
end