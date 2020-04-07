require 'squib'

# This demonstrates the many ways you can save file to save_png and the like
Squib::Deck.new(width: 50, height: 50, cards: 2) do
  background color: :white
  text str: (0..16).to_a, font: 'Arial Bold 12'

  # three digits, e.g. save_three_digits_000.png
  save_png prefix: 'save_three_digits_', count_format: '%03d'

  # foo_0.png
  # bar_1.png
  save_png prefix: ['foo_', 'bar_'], count_format: '%01d'

  # foo.png
  # bar.png
  save_png prefix: ['foo', 'bar'], count_format: ''

  # thief.png
  # thug.png
  data = csv data: "filename\nthief\nthug"
  save_png prefix: data.filename, count_format: ''

end
