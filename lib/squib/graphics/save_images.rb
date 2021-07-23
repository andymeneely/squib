require_relative 'cairo_context_wrapper'

module Squib
  class Card

    # :nodoc:
    # @api private
    def save_png(batch, shadow)
      surface = if preprocess_save?(batch, shadow)
                  w, h = compute_dimensions(batch.rotate, batch.trim)
                  preprocessed_save(w, h, batch, shadow)
                else
                  @cairo_surface
                end
      write_png(surface, index, batch)
    end

    # :nodoc:
    # @api private
    def preprocess_save?(batch, shadow)
      batch.rotate != false || batch.trim > 0 || !(shadow.shadow_radius.nil?)
    end

    def compute_dimensions(rotate, trim)
      if rotate
        [ @height - 2 * trim, @width - 2 * trim ]
      else
        [ @width - 2 * trim, @height - 2 * trim ]
      end
    end

    def preprocessed_save(w, h, batch, shadow)
      new_cc = Cairo::Context.new(Cairo::ImageSurface.new(w, h))
      trim_radius = batch.trim_radius
      if batch.rotate != false
        new_cc.translate w * 0.5, h * 0.5
        new_cc.rotate batch.angle
        new_cc.translate h * -0.5, w * -0.5
        new_cc.rounded_rectangle(0, 0, h, w, trim_radius, trim_radius)
      else
        new_cc.rounded_rectangle(0, 0, w, h, trim_radius, trim_radius)
      end
      new_cc.clip
      new_cc.set_source(@cairo_surface, -batch.trim, -batch.trim)
      new_cc.paint
      new_cc.reset_clip
      new_cc = drop_shadow(new_cc, shadow, batch) unless shadow.shadow_radius.nil?
      return new_cc.target
    end

    # pseudo-blur behave weirdly with a radius of 0 - wrapping
    def blur(cc, r, &block)
      if r == 0
        yield(block)
      else
        cc.pseudo_blur(r, &block)
      end
    end

    def drop_shadow(cc, s, batch)
      off_x = s.shadow_offset_x
      off_y = s.shadow_offset_y
      s_trim = s.shadow_trim
      s_rad = s.shadow_radius
      new_w = cc.target.width  + off_x + 3 * s_rad - (2 * s_trim)
      new_h = cc.target.height + off_y + 3 * s_rad - (2 * s_trim)
      new_cc = Squib::Graphics::CairoContextWrapper.new(
        Cairo::Context.new(Cairo::ImageSurface.new(new_w, new_h)))
      blur(new_cc, s_rad) do
        # fill in with shadow color
        new_cc.set_source_squibcolor s.shadow_color
        new_cc.rectangle 0, 0, new_cc.target.width, new_cc.target.height
        new_cc.fill
        # then, paint but blend with :dest_in to get a shadow-shaped drawing
        new_cc.set_source cc.target, s_rad + off_x, s_rad + off_y
        new_cc.operator = :dest_in # see https://www.cairographics.org/operators/
        new_cc.paint
      end
      new_cc.set_source cc.target, s_rad, s_rad
      new_cc.operator = :over
      new_cc.paint
      return new_cc
    end

    def write_png(surface, i, b)
      filename = "#{b.dir}/#{b.prefix}#{b.count_format % i}#{b.suffix}.png"
      surface.write_to_png filename
    end

  end
end
