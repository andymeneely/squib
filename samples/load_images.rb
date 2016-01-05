require 'squib'

Squib::Deck.new(width: 825, height: 1125, cards: 1, config: 'load_images_config.yml') do
  background color: '#0b7c8e'
  rect x: 38, y: 38, width: 750, height: 1050, x_radius: 38, y_radius: 38

  png file: 'shiny-purse.png', x: 620, y: 75 # no scaling is done by default
  svg file: 'spanner.svg', x: 620, y: 218

  # Can be scaled if width and height are set
  svg file: 'spanner.svg', x: 50, y: 50, width: 250, height: 250
  png file: 'shiny-purse.png', x: 305, y: 50, width: 250, height: 250
  #...but PNGs will warn if it's an upscale, unless you disable them in config.yml

  # Can be scaled using just width or height, if one of them is set to :scale
  svg file: 'spanner.svg', x: 200, y: 350, width: 35,     height: :scale
  svg file: 'spanner.svg', x: 200, y: 390, width: :scale, height: 35
  png file: 'shiny-purse.png', x: 240, y: 350, width: 35,     height: :scale
  png file: 'shiny-purse.png', x: 240, y: 390, width: :scale, height: 35

  # You can also crop the loaded images, so you can work from a sprite sheet
  png file: 'sprites.png', x: 300, y: 350  # entire sprite sheet
  png file: 'sprites.png', x: 300, y: 425, # just the robot golem image
      crop_x: 0, crop_y: 0, crop_corner_radius: 10,
      crop_width: 64, crop_height: 64
  png file: 'sprites.png', x: 400, y: 425, # just the drakkar ship image
      crop_x: 64, crop_y: 0, crop_corner_x_radius: 25, crop_corner_y_radius: 25,
      crop_width: 64, crop_height: 64
  png file: 'sprites.png', x: 500, y: 415, # just the drakkar ship image, rotated
      crop_x: 64, crop_y: 0, crop_corner_x_radius: 25, crop_corner_y_radius: 25,
      crop_width: 64, crop_height: 64, angle: Math::PI / 6

  # Cropping also works on SVGs too
  svg file: 'spanner.svg', x: 300, y: 500, width: 64, height: 64,
      crop_x: 32, crop_y: 32, crop_width: 32, crop_height:32

  # We can flip our images too
  png file: 'sprites.png', x: 300, y: 535, flip_vertical: true, flip_horizontal: true
  svg file: 'spanner.svg', x: 300, y: 615, width: 64, height: 64,
      flip_vertical: true, flip_horizontal: true

  # We can also limit our rendering to a single object, if the SVG ID is set
  svg file: 'spanner.svg', id: '#backdrop', x: 50, y: 350, width: 75, height: 75
  # Squib prepends a #-sign if one is not specified
  svg file: 'spanner.svg', id: 'backdrop', x: 50, y: 450, width: 125, height: 125

  # We can also load SVGs as a string of XML
  svg data: File.read('spanner.svg'), x: 50, y: 600, width: 75, height: 75

  # The svg data field works nicely with modifying the SVG XML on-the-fly.
  # To run this one, do `gem install game_icons` and uncomment the following
  #
  # require 'game_icons'
  # svg data: GameIcons.get('angler-fish').recolor(fg: '#ccc', bg: '#333').string,
  #     x: 150, y: 600, width: 75, height: 75
  #
  # More examples at https://github.com/andymeneely/game_icons
  # (or `gem install game_icons`) to get & manipulate art from game-icons.net
  # Nokogiri (already included in Squib) is also great for XML manipulation.

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

  # Note that this method does nothing, even though it would normally fill up
  # the card. force_id: true looks to the id field to be non-empty to render.
  # This is useful if you have multiple different icons in one SVG file,
  # but sometimes want to use none.
  # e.g. id: [:attack, :defend, nil]
  svg file: 'spanner.svg', width: :deck, height: :deck,
      force_id: true, id: '' # <-- the important part

  save prefix: 'load_images_', format: :png
end
