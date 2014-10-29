require 'squib'

# Here's an exmaple of being able to scale a font
# based on the length of individual string.
# Handy for making minor font scales to fill text boxes.
def autoscale(str_array)
  str_array.inject([]) do | memo, str |
    case str.length
    when 0..10
      memo << 125
    when 11..20
      memo << 45
    else
      memo << 36
    end
  end
end

Squib::Deck.new(cards: 3) do
  background color: :white

  title = %w(ShortBig Medium_Length_Name Super_Duper_Long_Name)
  text str: title, x: 65, y: 400, align: :center, width: 700,
       font: 'Arial', font_size: autoscale(title), hint: :red

  save prefix: 'autoscale_', format: :png
end
