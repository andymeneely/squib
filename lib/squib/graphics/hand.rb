require 'squib/graphics/cairo_context_wrapper'

module Squib
  class Deck
    # Draw cards in a fan.
    # @api private
    def render_hand(range, radius, angle_range, trim, trim_radius, margin,
                    fill_color, dir, file)
      cards       = range.collect { |i| @cards[i] }
      center_x    = width / 2.0
      center_y    = radius + height
      out_size    = 3.0 * center_y
      angle_delta = (angle_range.last - angle_range.first) / cards.size
      cxt = Cairo::Context.new(Cairo::RecordingSurface.new(0, 0, out_size, out_size))
      cxt.translate(out_size / 2.0, out_size / 2.0)
      cxt.rotate(angle_range.first)
      cxt.translate(-width, -width)
      cards.each_with_index do |card, _i|
        cxt.translate(center_x, center_y)
        cxt.rotate(angle_delta)
        cxt.translate(-center_x, -center_y)
        card.use_cairo do |card_cxt|
          cxt.rounded_rectangle(trim, trim,
                                width - (2 * trim), height - (2 * trim),
                                trim_radius, trim_radius)
          cxt.clip
          cxt.set_source(card_cxt.target)
          cxt.paint
          cxt.reset_clip
        end
      end
      x, y, w, h = cxt.target.ink_extents # I love Ruby assignment ;)
      png_cxt = Squib::Graphics::CairoContextWrapper.new(Cairo::Context.new(Cairo::ImageSurface.new(w + 2 * margin, h + 2 * margin)))
      png_cxt.set_source_squibcolor(fill_color)
      png_cxt.paint
      png_cxt.translate(-x + margin, -y + margin)
      png_cxt.set_source(cxt.target)
      png_cxt.paint
      png_cxt.target.write_to_png("#{dir}/#{file}")
    end
  end
end
