require 'squib/graphics/cairo_context_wrapper'

module Squib
  class Deck

    # Draw cards in a fan.
    # @api private
    def render_hand(range, sheet, hand)
      cards       = range.collect { |i| @cards[i] }
      center_x    = width / 2.0
      center_y    = hand.radius + height
      out_size    = 3.0 * center_y
      angle_delta = (hand.angle_range.last - hand.angle_range.first) / cards.size
      cxt = Cairo::Context.new(Cairo::RecordingSurface.new(0, 0, out_size, out_size))
      cxt.translate(out_size / 2.0, out_size / 2.0)
      cxt.rotate(hand.angle_range.first)
      cxt.translate(-width, -width)
      cards.each_with_index do |card, i|
        cxt.translate(center_x, center_y)
        cxt.rotate(angle_delta)
        cxt.translate(-center_x, -center_y)
        card.use_cairo do |card_cxt|
          cxt.rounded_rectangle(sheet.trim, sheet.trim,
                                width - (2 * sheet.trim), height - (2 * sheet.trim),
                                sheet.trim_radius, sheet.trim_radius)
          cxt.clip
          cxt.set_source(card_cxt.target)
          cxt.paint
          cxt.reset_clip
        end
      end
      x, y, w, h = cxt.target.ink_extents # I love Ruby assignment ;)
      png_cxt = Squib::Graphics::CairoContextWrapper.new(Cairo::Context.new(Cairo::ImageSurface.new(w + 2*sheet.margin, h + 2*sheet.margin)))
      png_cxt.set_source_squibcolor(sheet.fill_color)
      png_cxt.paint
      png_cxt.translate(-x + sheet.margin, -y + sheet.margin)
      png_cxt.set_source(cxt.target)
      png_cxt.paint
      png_cxt.target.write_to_png sheet.full_filename
    end
  end
end
