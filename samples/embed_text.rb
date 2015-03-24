require 'squib'

Squib::Deck.new do
  background color: :white
  rect x: 0, y: 0, width: 825, height: 1125, stroke_width: 2.0

  embed_text = 'Take 11 :tool: and gain 2 :health:. Take <b>2</b> :tool: <i>and gain 3 :purse: if level 2.</i>'
  text(str: embed_text, font: 'Sans 21',
       x: 0, y: 0, width: 180, hint: :red,
       align: :left, ellipsize: false, justify: false) do |embed|
    embed.svg key: ':tool:',   width: 28, height: 28, dx: 0, dy: 3, file: 'spanner.svg'
    embed.svg key: ':health:', width: 28, height: 28, dx: 2, dy: 3, file: 'glass-heart.svg'
    embed.png key: ':purse:',  width: 28, height: 28, dx: 0, dy: 3, file: 'shiny-purse.png'
  end

  embed_text = 'Middle align: Take 1 :tool: and gain 2 :health:. Take 2 :tool: and gain 3 :purse:'
  text(str: embed_text, font: 'Sans 21',
       x: 200, y: 0, width: 180, height: 300, valign: :middle,
       align: :left, ellipsize: false, justify: false, hint: :cyan) do |embed|
    embed.svg key: ':tool:',   width: 28, height: 28, file: 'spanner.svg'
    embed.svg key: ':health:', width: 28, height: 28, file: 'glass-heart.svg'
    embed.png key: ':purse:',  width: 28, height: 28, file: 'shiny-purse.png'
  end

  embed_text = 'This :tool: will not align on the bottom properly. :purse:'
  text(str: embed_text, font: 'Sans 21',
       x: 400, y: 0, width: 180, height: 300, valign: :bottom,
       align: :left, ellipsize: false, justify: false, hint: :cyan) do |embed|
    embed.svg key: ':tool:',   width: 28, height: 28, file: 'spanner.svg'
    embed.svg key: ':health:', width: 28, height: 28, file: 'glass-heart.svg'
    embed.png key: ':purse:',  width: 28, height: 28, file: 'shiny-purse.png'
  end

  embed_text = 'This :tool: will not align on the bottom properly. :purse:'
  text(str: embed_text, font: 'Sans 21',
       x: 400, y: 350, width: 180, height: 300, valign: :bottom,
       align: :left, ellipsize: false, justify: false, hint: :cyan) do |embed|
    # embed.svg key: ':tool:',   width: 28, height: 28, file: 'spanner.svg'
    # embed.svg key: ':health:', width: 28, height: 28, file: 'glass-heart.svg'
    # embed.png key: ':purse:',  width: 28, height: 28, file: 'shiny-purse.png'
  end

  text str: 'But this does align properly', font: 'Sans 21', 
       x: 600, y: 0, width: 180, height: 300, valign: :bottom,
       align: :left, ellipsize: false, justify: false, hint: :cyan

  save_png prefix: 'embed_'
end