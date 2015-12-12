module Squib
  class Card

    # :nodoc:
    # @api private
    def save_png(batch)
      surface = if preprocess_save?(batch)
                  preprocessed_save(batch.angle, batch.trim, batch.trim_radius)
                else
                  @cairo_surface
                end
      write_png(surface, index, batch.dir, batch.prefix, batch.count_format)
    end

    # :nodoc:
    # @api private
    def preprocess_save?(batch)
      batch.rotate || batch.trim > 0
    end

    def preprocessed_save(angle, trim, trim_radius)
      new_width, new_height = @width - 2*trim, @height - 2*trim
      new_cc = Cairo::Context.new(Cairo::ImageSurface.new(new_width, new_height))
      new_cc.translate(new_width * 0.5, new_height * 0.5)
      new_cc.rotate(angle)
      new_cc.translate(new_width * -0.5, new_height * -0.5)
      new_cc.set_source(@cairo_surface, -trim, -trim)
      new_cc.rounded_rectangle(0, 0, new_width, new_height, trim_radius, trim_radius)
      new_cc.clip
      new_cc.paint
      new_cc.target
    end

    def write_png(surface, i, dir, prefix, count_format)
      surface.write_to_png("#{dir}/#{prefix}#{count_format % i}.png")
    end

  end
end
