require 'squib'

Squib::Deck.new(width: 825, height: 1125, cards: 1) do
  background color: :white

  y = 0
  text color: '#f00', str: '3-hex', x: 50, y: y += 50
  text color: '#f00', str: '3-hex (alpha)', x: 50, y: y += 50
  text color: '#ff0000', str: '6-hex', x: 50, y: y += 50
  text color: '#ff000099', str: '8-hex(alpha)', x: 50, y: y += 50
  text color: '#ffff00000000', str: '12-hex', x: 50, y: y += 50
  text color: '#ffff000000009999', str: '12-hex (alpha)', x: 50, y: y += 50
  text color: :burnt_orange, str: 'Symbols of constants too', x: 50, y: y += 50
  text color: '(0,0)(400,0) blue@0.0 red@1.0', str: 'Linear gradients!', x: 50, y: y += 50
  text color: '(200,500,10)(200,500,100) blue@0.0 red@1.0', str: 'Radial gradients!', x: 50, y: y += 50
  # see gradients.rb sample for more on gradients

  save_png prefix: 'colors_'
end

# This script generates a table of the built-in constants
colors = (Cairo::Color.constants - %i(HEX_RE Base RGB CMYK HSV X11))
colors.sort_by! do |c|
  hsv = Cairo::Color.parse(c).to_hsv
  [(hsv.hue / 16.0).to_i, hsv.value, hsv.saturation]
end
w, h = 300, 50
deck_height = 4000
deck_width = (colors.size / ((deck_height / h) + 1)) * w
Squib::Deck.new(width: deck_width, height: deck_height) do
  background color: :white
  x, y = 0, 0
  colors.each_with_index do |color, i|
    rect x: x, y: y, width: w, height: h, fill_color: color
    text str: color.to_s, x: x + 5, y: y + 13, font: 'Sans Bold 5',
         color: (Cairo::Color.parse(color).to_hsv.v > 0.9) ? '#000' : '#fff'
    y += h
    if y > deck_height
      x += w
      y = 0
    end
  end
  save_png prefix: 'color_constants_'
end
