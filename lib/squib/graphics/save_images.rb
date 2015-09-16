module Squib
  class Card

    # :nodoc:
    # @api private
    def save_png(batch)
      surface = if batch.rotate
                  rotated_image(batch.angle)
                else
                  surface = @cairo_surface
                end
      write_png(surface, index, batch.dir, batch.prefix, batch.count_format)
    end

    # :nodoc:
    # @api private
    def rotated_image(angle)
      rotated_cc = Cairo::Context.new(Cairo::ImageSurface.new(@height, @width) )
      rotated_cc.translate(@height * 0.5, @width * 0.5)
      rotated_cc.rotate(angle)
      rotated_cc.translate(@width * -0.5, @height * -0.5)
      rotated_cc.set_source(@cairo_surface)
      rotated_cc.paint
      rotated_cc.target
    end
    # :nodoc:
    # @api private
    def write_png(surface, i, dir, prefix, count_format)
      surface.write_to_png("#{dir}/#{prefix}#{count_format % i}.png")
    end

  end
end
