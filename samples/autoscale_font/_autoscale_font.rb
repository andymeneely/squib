require 'squib'

# Here's an example of being able to scale a font
# based on the length of individual string.
# Handy for making minor font scales to fill text boxes.
def autoscale(str_array)
  str_array.map do | str |
    case str.length
    when 0..15
      32
    when 16..20
      18
    else
      12
    end
  end
end

Squib::Deck.new(width: 300, height: 100, cards: 3) do
  background color: :white
  rect
  title = ['Short & Big',
           'Medium Length & Size',
           'Super duper long string here, therefore a smaller font.']
  text str: title, font: 'Arial', font_size: autoscale(title),
       x: 10, y:10, align: :center, width: 280, ellipsize: false, hint: :red

  save_sheet dir: '.', columns: 3
end
