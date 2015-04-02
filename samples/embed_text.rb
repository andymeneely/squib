require 'squib'

Squib::Deck.new do
  background color: :white
  rect x: 0, y: 0, width: 825, height: 1125, stroke_width: 2.0

  # embed_text = 'Take 11 :tool: and gain 2 :health:. Take <b>2</b> :tool: <i>and gain 3 :purse: if level 2.</i>'
  # text(str: embed_text, font: 'Sans 21',
  #      x: 0, y: 0, width: 180, hint: :red,
  #      align: :left, ellipsize: false, justify: false) do |embed|
  #   # Notice how we use dx and dy to adjust the icon to not rest directly on the baseline
  #   embed.svg key: ':tool:',   width: 28, height: 28, dx:  0, dy: 4, file: 'spanner.svg'
  #   embed.svg key: ':health:', width: 28, height: 28, dx: -2, dy: 4, file: 'glass-heart.svg'
  #   embed.png key: ':purse:',  width: 28, height: 28, dx:  0, dy: 4, file: 'shiny-purse.png'
  # end

  embed_text = 'Middle align: Take 1 :tool: and gain 2 :health:. Take 2 :tool: and gain 3 :purse:'
  text(str: embed_text, font: 'Sans 21',
       x: 200, y: 0, width: 180, height: 300, valign: :middle,
       align: :left, ellipsize: false, justify: false, hint: :cyan) do |embed|
    embed.svg key: ':tool:',   width: 28, height: 28, file: 'spanner.svg'
    embed.svg key: ':health:', width: 28, height: 28, file: 'glass-heart.svg'
    embed.png key: ':purse:',  width: 28, height: 28, file: 'shiny-purse.png'
  end

  # embed_text = 'This :tool: aligns on the bottom properly. :purse:'
  # text(str: embed_text, font: 'Sans 21',
  #      x: 400, y: 0, width: 180, height: 300, valign: :bottom,
  #      align: :left, ellipsize: false, justify: false, hint: :green) do |embed|
  #   embed.svg key: ':tool:',   width: 28, height: 28, file: 'spanner.svg'
  #   embed.svg key: ':health:', width: 28, height: 28, file: 'glass-heart.svg'
  #   embed.png key: ':purse:',  width: 28, height: 28, file: 'shiny-purse.png'
  # end

  # embed_text = 'Wrapping multiples: These are 1 :tool::tool::tool: and these are multiple :tool::tool: :tool::tool:'
  # text(str: embed_text, font: 'Sans 21',
  #      x: 600, y: 0, width: 180, height: 300, valign: :middle,
  #      align: :left, ellipsize: false, justify: false, hint: :cyan) do |embed|
  #   embed.svg key: ':tool:',   width: 28, height: 28, file: 'spanner.svg'
  # end

  # embed_text = ':tool:Justify will :tool: work too, and :purse: with more words just for fun'
  # text(str: embed_text, font: 'Sans 21',
  #      x: 0, y: 320, width: 180, height: 300, valign: :bottom,
  #      align: :left, ellipsize: false, justify: true, hint: :magenta) do |embed|
  #   embed.svg key: ':tool:',   width: 28, height: 28, file: 'spanner.svg'
  #   embed.svg key: ':health:', width: 28, height: 28, file: 'glass-heart.svg'
  #   embed.png key: ':purse:',  width: 28, height: 28, file: 'shiny-purse.png'
  # end

  # embed_text = 'Right-aligned works :tool: with :health: and :purse:'
  # text(str: embed_text, font: 'Sans 21',
  #      x: 200, y: 320, width: 180, height: 300, valign: :bottom,
  #      align: :right, ellipsize: false, justify: false, hint: :magenta) do |embed|
  #   embed.svg key: ':tool:',   width: 28, height: 28, file: 'spanner.svg'
  #   embed.svg key: ':health:', width: 28, height: 28, file: 'glass-heart.svg'
  #   embed.png key: ':purse:',  width: 28, height: 28, file: 'shiny-purse.png'
  # end

  # embed_text = ':tool:Center-aligned works :tool: with :health: and :purse:'
  # text(str: embed_text, font: 'Sans 21',
  #      x: 400, y: 320, width: 180, height: 300,
  #      align: :center, ellipsize: false, justify: false, hint: :magenta) do |embed|
  #   embed.svg key: ':tool:',   width: 28, height: 28, file: 'spanner.svg'
  #   embed.svg key: ':health:', width: 28, height: 28, file: 'glass-heart.svg'
  #   embed.png key: ':purse:',  width: 28, height: 28, file: 'shiny-purse.png'
  # end

  save_png prefix: 'embed_'
end