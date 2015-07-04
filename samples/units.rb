require 'squib'

Squib::Deck.new do
  background color: '#ddd'

  # We can use our DSL-method to use inches
  # Computed using @dpi (set to 300 by default)
  bleed      = inches(0.125)
  cut_width  = inches(2.5)
  cut_height = inches(3.5)
  rect x: bleed, y: bleed, radius: 25,
       width: cut_width, height: cut_height

  # We can also use cm this way
  cm(2)

  # Or we can use a string ending with cm or in
  #  (even cleaner in Yaml since we don't need quotes!)
  safe_margin = '0.25in'
  safe_width  = '2.25in'
  safe_height = '3.25in'
  rect x: safe_margin, y: safe_margin,
       width: safe_width, height: safe_height, radius: 25

  rect x: '4cm', y: '4 cm  ', width: 100, height: 100

  save prefix: 'units_', format: :png
end
