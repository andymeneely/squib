require 'squib'

# Built-in layouts are easy to use and extend
Squib::Deck.new(cards: 8, layout: 'playing-card.yml') do
  background color: :white
  rect x: 37, y: 37, width: 750, height: 1050, fill_color: :black, radius: 25
  rect x: 75, y: 75, width: 675, height: 975, fill_color: :white, radius: 20
  text str: ('A'..'H').to_a, layout: :bonus_ul, font: 'Sans bold 100'
  # hand range: :all,
  #      center_x: :auto, center_y: :auto,
  #      angle_start: 0, angle_end: Math::PI,
  #      width: :auto, height: :auto
  # save_png prefix: 'hand_'
  #
  # Here's the hacky version
  # So much hardcoded magic to get this to work. Math is hard.
  # Idea: getting the final image surface extents is hard math for me. Maybe
  #       just put it on a recording surface, then get the extents.
  #       Can't seem to create unbounded surfaces in rcairo, so just make it
  #       massively large enough. Paint the recording surface with proper margins
  #       at the end
  cxt = Cairo::Context.new(Cairo::ImageSurface.new(2 * 1.3 * height, 2 * 1.3 * height))
  cxt.translate( 1.3 * height , 1.3 * height)
  cxt.rotate(Math::PI / -4.0)
  cxt.translate( -1.3 * height, -1.3 * height)
  cxt.translate(500, 500) # I don't even know why I need this
  angle = (Math::PI / 2.0) / cards.size
  radius_x, radius_y = 0 + (width / 2.0), 1.3 * height
  each_with_index do |card, i|
    cxt.translate(radius_x, radius_y)
    cxt.rotate(angle)
    cxt.translate(-radius_x, -radius_y)
    card.use_cairo do |card_cxt|
      cxt.rounded_rectangle(37, 37, 825-75, 1125-75, 25, 25)
      cxt.clip
      cxt.set_source(card_cxt.target)
      cxt.paint
      cxt.reset_clip
    end
  end

  cxt.target.write_to_png('_output/hand.png')

end

