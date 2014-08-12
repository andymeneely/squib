module Squib
  class Card

    # :nodoc:
    # @api private 
    def save_png(i, dir, prefix, rotate)
      if rotate
        surface = rotated_image
      else
        surface = @cairo_surface
      end
      write_png(surface, i, dir, prefix)
    end

    # :nodoc:
    # @api private
    def rotated_image
      rotated_cc = Cairo::Context.new(Cairo::ImageSurface.new(@height, @width) )
      rotated_cc.translate(@height * 0.5, @width * 0.5)
      rotated_cc.rotate(0.5 * Math::PI)
      rotated_cc.translate(@width * -0.5, @height * -0.5)
      rotated_cc.set_source(@cairo_surface)
      rotated_cc.paint
      rotated_cc.target
    end
    # :nodoc:
    # @api private 
    def write_png(surface, i, dir, prefix)
      surface.write_to_png("#{dir}/#{prefix}#{i}.png")
    end

  end
end