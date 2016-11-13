require 'squib'
require 'squib/sample_helpers'

Squib::Deck.new(width: 1000, height: 1250) do
  draw_graph_paper width, height

  sample 'Font strings are quite expressive. Specify family, modifiers, then size. Font names with spaces in them should end with a comma to help with parsing.' do |x, y|
    text font: 'Arial bold italic 32', str: 'Bold and italic!', x: x, y: y - 50
    text font: 'Arial weight=300 32', str: 'Light bold!', x: x, y: y
    text font: 'Times New Roman, 32', str: 'Times New Roman', x: x, y: y + 50
    text font: 'NoSuchFont,Arial 32', str: 'Arial Backup', x: x, y: y + 100
  end

  sample 'Specify width and height to see a text box. Also: set "hint" to see the extents of your text box' do |x, y|
    text str: 'This has fixed width and height.', x: x, y: y,
         hint: :red, width: 300, height: 100, font: 'Serif bold 24'
  end

  sample 'If you specify the width only, the text will ellipsize.' do |x, y|
    text str: 'The meaning of life is 42', x: x - 50, y: y,
         hint: :red, width: 350, font: 'Serif bold 22'
  end

  sample 'If you specify the width only, and turn off ellipsize, the height will auto-stretch.' do |x, y|
    text str: 'This has fixed width, but not fixed height.', x: x, y: y,
         hint: :red, width: 300, ellipsize: false, font: 'Serif bold 24'
  end

  sample 'The text method returns the ink extents of each card\'s rendered text. So you can custom-fit a shape around it.' do |x, y|
    ['Auto fit!', 'Auto fit!!!!' ].each.with_index do |str, i|
      text_y = y + i * 50
      extents = text str: str, x: x, y: text_y, font: 'Sans Bold 24'

      # Extents come back as an array of hashes, which can get split out like this
      text_width  = extents[0][:width]
      text_height = extents[0][:height]
      rect x: x, y: text_y, width: text_width, height: text_height, radius: 10,
           stroke_color: :purple, stroke_width: 3
    end
  end

  sample 'Text can be rotated about the upper-left corner of the text box. Unit is in radians.' do |x, y|
    text str: 'Rotated', hint: :red, x: x, y: y, angle: Math::PI / 6
  end

  save_png prefix: '_text_', dir: '.'
end
