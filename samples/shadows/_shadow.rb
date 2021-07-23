require 'squib'
# The save_png method supports drop shadows on the final save
# This is useful for when you want to generate images for your rulebook

Squib::Deck.new(width: 100, height: 150) do
  background color: '#abc'
  svg file: '../spanner.svg',
      x: 'middle - 25', y: 'middle - 25',
      width: 50, height: 50

  # Shadows off by default, i.e. shadow_radius is nil
  # So our final dimensions are 100 - 2*15 and 150-2*15
  save_png prefix: 'no_shadow_', trim: 15, trim_radius: 15

  # Here's a nice-looking drop shadow
  # Defaults are designed to be generally good, so I recommend just
  # trying out a shadow_radius of 3 to 10 and see how it looks first
  save_png prefix: 'with_shadow_', trim: 15, trim_radius: 15,
           shadow_radius: 8,
           shadow_offset_x: 3, shadow_offset_y: 3,  # about r / 2.5 looks good
           shadow_trim: 2.5, # about r/ 3 looks good
           shadow_color: '#101010aa' #tip: start the shadow color kinda transparent

  # Don't want a blur? Use a radius of 0
  save_png prefix: 'no_blur_', trim: 15, trim_radius: 15,
           shadow_radius: 0

  # Ok this next stop is crazytown, but it does give you ultimate control
  # Remember that all Squib colors can also be gradients.
  # They can be clunky but they do work here.
  #   - x,y's are centered in the card itself
  #   - stops go from fully empty to fully black
  #   - we need to still turn on radius to get the effect
  #   - but, this makes the upper-left corner not have a glowing effect and
  #     have a harder edge, which (to my eye at least) feels more realistic
  #     since the card would obscure the upper-left shadow at that angle
  #   - this also allows you have a larger, softer blur without making it look
  #     like it's glowing
  #
  # Oh just because it's easier to write we can use a ruby heredoc
  save_png prefix: 'gradient_blur_', trim: 15, trim_radius: 15,
           shadow_radius: 10,
           shadow_color: <<~EOS
              (25,25)
              (175,175)
              #0000@0.0
              #000f@1.0
           EOS

  # This one looks weird I know but it's for regression testing
  save_png prefix: 'with_shadow_test_',
           trim: 15, trim_radius: 15, rotate: :clockwise,
           shadow_offset_x: 5, shadow_offset_y: 25, shadow_radius: 10,
           shadow_trim: 10,
           shadow_color: '#123'
end

Squib::Deck.new(width:50, height: 50) do

  # What if we had a transparent card but just some shapes?
  # Like chits or something

  # background defaults to fully transparent here

  png file: 'doodle.png'

  save_png prefix: 'transparent_bg_shadow_',
           shadow_radius: 2,
           shadow_offset_x: 2, shadow_offset_y: 2,
           shadow_color: :black

end