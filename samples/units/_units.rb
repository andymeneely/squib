require 'squib'

Squib::Deck.new(width: '1.5in', height: '1.5in') do
  background color: :white

  # We can use our DSL-method to use inches
  # Computed using @dpi (set to 300 by default)
  bleed = inches(0.125)
  cut   = inches(1.25)
  rect x: bleed, y: bleed,
       width: cut, height: cut,
       dash: '0.5mm 0.5mm' # yes, units are in dashes too

  # other units too
  cm(2)             # We can also use cm this way
  cm(2) + inches(2) # We can mix units too

  # Or we can use a string ending with cm or in
  safe_margin = '0.25 in' #you can have a space too
  safe_width  = '1 in'
  safe_height = '1.0 in  ' # trailing space is ok too
  rect x: safe_margin, y: safe_margin,
  	   width: safe_width, height: safe_height,
       radius: '2 mm '

  # Angles are also automatically converted to radians if you use deg
  svg file: '../spanner.svg',
      x: 100, y: 100, width: 40, height: 40, angle: '30deg'

  # We can also do stuff in layout. Check out the yml file...
  #  (even cleaner in Yaml since we don't need quotes!)
  use_layout file: 'using_units.yml'
  text str: 'Hello.', layout: :example
  svg file: '../spanner.svg', layout: :angled

  save prefix: 'units_', format: :png

  # But wait... there's more! See _shorthands.rb for more fanciness with units
end
