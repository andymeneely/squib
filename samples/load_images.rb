require 'squib'

Squib::Deck.new(width: 825, height: 1125, cards: 1) do
  background color: '#0b7c8e'
  rect x: 38, y: 38, width: 750, height: 1050, x_radius: 38, y_radius: 38

  png file: 'shiny-purse.png', x: 620, y: 75 # no scaling is done by default
  svg file: 'spanner.svg', x: 620, y: 218

  # Can be scaled if width and height are set
  svg file: 'spanner.svg', x: 50, y: 50, width: 250, height: 250
  png file: 'shiny-purse.png', x: 305, y: 50, width: 250, height: 250
  #...but PNGs will warn if it's an upscale

  # We can also limit our rendering to a single object, if the SVG ID is set
  svg file: 'spanner.svg', id: '#backdrop', x: 50, y: 350, width: 75, height: 75
  # Squib prepends a #-sign if one is not specified
  svg file: 'spanner.svg', id: 'backdrop', x: 50, y: 450, width: 125, height: 125

  # WARNING! If you choose to use the SVG ID, the x-y coordinates are still
  # relative to the SVG page. See this example in an SVG editor
  svg file: 'offset.svg', id: 'thing',  x: 0, y: 0, width: 600, height: 600

  # Over 15 different blending operators are supported.
  # See http://cairographics.org/operators
  # Alpha transparency too
  png file: 'ball.png', x: 50, y: 700
  png file: 'grit.png', x: 70, y: 750, blend: :color_burn, alpha: 0.75

  # Images can be rotated around their upper-left corner
  png file: 'shiny-purse.png', x: 300, y: 700, angle: 0.0 # default (no rotate)
  png file: 'shiny-purse.png', x: 300, y: 800, angle: Math::PI / 4
  svg file: 'spanner.svg',     x: 300, y: 900, angle: Math::PI / 2 - 0.1

  # Images can also be used as masks instead of being directly painted.
  # This is particularly useful for switching directly over to black-and-white for printing
  # Or, if you want the same image to be used but with different colors/gradients
  svg mask: '#00ff00',
      file: 'glass-heart.svg',
      x: 500, y: 600, width: 200, height: 200
  svg mask: '(0,0)(0,500) #ccc@0.0 #333@1.0',
      file: 'glass-heart.svg',
      x: 500, y: 800, width: 200, height: 200

  # Masks are based on the alpha channel, so this is just a magenta square
  png mask: :magenta, file: 'shiny-purse.png',
      x: 650, y: 950

  save prefix: 'load_images_', format: :png
end
