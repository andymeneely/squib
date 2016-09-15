require 'squib'

Squib::Deck.new do
  background color: :white
  rect x: 0, y: 0, width: 825, height: 1125, stroke_width: 2.0

  embed_text = 'Take 11 :tool: and gain 2 :health:. Take <b>2</b> :tool: <i>and gain 3 :purse: if level 2.</i>'
  text(str: embed_text, font: 'Sans 21',
       x: 0, y: 0, width: 180, hint: :red,
       align: :left, ellipsize: false, justify: false) do |embed|
    embed.svg key: ':tool:',   width: 28, height: 28, file: 'spanner.svg'
    embed.svg key: ':health:', width: 28, height: 28, file: 'glass-heart.svg'
    embed.png key: ':purse:',  width: 28, height: 28, file: 'shiny-purse.png'
  end

  embed_text = 'Middle align: Take 1 :tool: and gain 2 :health:. Take 2 :tool: and gain 3 :purse:'
  text(str: embed_text, font: 'Sans 21',
       x: 200, y: 0, width: 180, height: 300, valign: :middle,
       align: :left, ellipsize: false, justify: false, hint: :cyan) do |embed|
    embed.svg key: ':tool:',   width: 28, height: 28, file: 'spanner.svg'
    embed.svg key: ':health:', width: 28, height: 28, file: 'glass-heart.svg'
    embed.png key: ':purse:',  width: 28, height: 28, file: 'shiny-purse.png'
  end

  embed_text = 'This :tool: aligns on the bottom properly. :purse:'
  text(str: embed_text, font: 'Sans 21',
       x: 400, y: 0, width: 180, height: 300, valign: :bottom,
       align: :left, ellipsize: false, justify: false, hint: :green) do |embed|
    embed.svg key: ':tool:',   width: 28, height: 28, file: 'spanner.svg'
    embed.svg key: ':health:', width: 28, height: 28, file: 'glass-heart.svg'
    embed.png key: ':purse:',  width: 28, height: 28, file: 'shiny-purse.png'
  end

  embed_text = 'Yes, this wraps strangely. We are trying to determine the cause. These are 1 :tool::tool::tool: and these are multiple :tool::tool: :tool::tool:'
  text(str: embed_text, font: 'Sans 18',
       x: 600, y: 0, width: 180, height: 300, wrap: :word_char,
       align: :left, ellipsize: false, justify: false, hint: :cyan) do |embed|
    embed.svg key: ':tool:', width: 28, height: 28, file: 'spanner.svg'
  end

  embed_text = ':tool:Justify will :tool: work too, and :purse: with more words just for fun'
  text(str: embed_text, font: 'Sans 21',
       x: 0, y: 320, width: 180, height: 300, valign: :bottom,
       align: :left, ellipsize: false, justify: true, hint: :magenta) do |embed|
    embed.svg key: ':tool:',   width: 28, height: 28, file: 'spanner.svg'
    embed.svg key: ':health:', width: 28, height: 28, file: 'glass-heart.svg'
    embed.png key: ':purse:',  width: 28, height: 28, file: 'shiny-purse.png'
  end

  embed_text = 'Right-aligned works :tool: with :health: and :purse:'
  text(str: embed_text, font: 'Sans 21',
       x: 200, y: 320, width: 180, height: 300, valign: :bottom,
       align: :right, ellipsize: false, justify: false, hint: :magenta) do |embed|
    embed.svg key: ':tool:',   width: 28, height: 28, file: 'spanner.svg'
    embed.svg key: ':health:', width: 28, height: 28, file: 'glass-heart.svg'
    embed.png key: ':purse:',  width: 28, height: 28, file: 'shiny-purse.png'
  end

  embed_text = ':tool:Center-aligned works :tool: with :health: and :purse:'
  text(str: embed_text, font: 'Sans 21',
       x: 400, y: 320, width: 180, height: 300,
       align: :center, ellipsize: false, justify: false, hint: :magenta) do |embed|
    embed.svg key: ':tool:',   width: 28, height: 28, data: File.read('spanner.svg')
    embed.svg key: ':health:', width: 28, height: 28, file: 'glass-heart.svg'
    embed.png key: ':purse:',  width: 28, height: 28, file: 'shiny-purse.png'
  end

  embed_text = 'Markup --- and typography replacements --- with ":tool:" icons <i>won\'t</i> fail'
  text(str: embed_text, font: 'Serif 18', markup: true,
       x: 600, y: 320, width: 180, height: 300,
       align: :center, hint: :magenta) do |embed|
    embed.svg key: ':tool:',   width: 28, height: 28, file: 'spanner.svg'
  end

  embed_text = ':tool:' # JUST the icon
  text(str: embed_text, x: 0, y: 640, width: 180, height: 50, markup: true,
     font: 'Arial 21', align: :center, valign: :middle, hint: :red) do |embed|
    embed.svg key: ':tool:', width: 28, height: 28, file: 'spanner.svg'
  end

  embed_text = ':purse:' # JUST the icon
  text(str: embed_text, x: 200, y: 640, width: 180, height: 50, markup: true,
     font: 'Arial 21', align: :center, valign: :middle, hint: :red) do |embed|
    embed.png key: ':purse:', width: 28, height: 28, file: 'shiny-purse.png'
  end

  embed_text = ":tool: Death to Nemesis bug 103!! :purse:"
  text(str: embed_text, font: 'Sans Bold 24', stroke_width: 2,
       color: :red, stroke_color: :blue, dash: '3 3', align: :left,
       valign: :middle, x: 0, y: 700, width: 380, height: 150,
       hint: :magenta) do |embed|
    embed.svg key: ':tool:', file: 'spanner.svg', width: 32, height: 32
    embed.png key: ':purse:', file: 'shiny-purse.png', width: 32, height: 32
  end

  embed_text = 'You can adjust the icon with dx and dy. Normal: :tool: Adjusted: :heart:'
  text(str: embed_text, font: 'Sans 18', x: 400, y: 640, width: 180,
       height: 300, hint: :magenta) do |embed|
    embed.svg key: ':tool:', width: 28, height: 28, file: 'spanner.svg'
    embed.svg key: ':heart:', width: 28, height: 28, dx: 10, dy: 10,
              file: 'glass-heart.svg'
  end

  embed_text = "Native sizes work too\n:tool:\n\n\n\n\n\n:shiny-purse:\n\n\n\n\n\n:tool2:"
  text(str: embed_text, font: 'Sans 18', x: 600, y: 640, width: 180,
       height: 475, hint: :magenta) do |embed|
    embed.svg key: ':tool:', width: :native, height: :native,
              file: 'spanner.svg'
    embed.svg key: ':tool2:', width: :native, height: :native,
              data: File.open('spanner.svg','r').read
    embed.png key: ':shiny-purse:', width: :native, height: :native,
              file: 'shiny-purse.png'
  end

  save_png prefix: 'embed_'
end

Squib::Deck.new(cards: 3) do
  str = 'Take 1 :tool: and gain 2 :health:.'
  text(str: str, font: 'Sans', font_size: [18, 26, 35],
       x: 0, y: 0, width: 180, height: 300, valign: :bottom,
       align: :left, ellipsize: false, justify: false, hint: :cyan) do |embed|
    embed.svg key: ':tool:',   width: [28, 42, 56], height: [28, 42, 56], file: 'spanner.svg'
    embed.svg key: ':health:', width: [28, 42, 56], height: [28, 42, 56], file: 'glass-heart.svg'
  end
  save_sheet prefix: 'embed_multisheet_', columns: 3
end
