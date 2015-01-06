module Squib
  class Deck

    # So the Cairo people have said over and over again that they won't support the 3x3 matrices that would handle perspective transforms.
    # Since our perspective transform needs are a bit simpler, we can use a "striping method" that does the job for us.
    # It's a little bit involved, but it works well enough for limited ranges of our parameters.
    # These were also helpful:
    #  http://kapo-cpp.blogspot.com/2008/01/perspective-effect-using-cairo.html
    #  http://zetcode.com/gui/pygtk/drawingII/
    # :nodoc:
    # @api private
    def render_showcase(range,
                        trim, trim_radius, scale, offset, fill_color,
                        reflect_offset, reflect_percent, reflect_strength, margin, face_right,
                        dir, file_to_save)
      out_width = range.size * ((@width - 2*trim) * scale * offset) + 2*margin
      out_height = reflect_offset + (1.0 + reflect_percent) * (@height - 2*trim) + 2*margin
      out_cc = Cairo::Context.new(Cairo::ImageSurface.new(out_width, out_height))
      out_cc.set_source_color(fill_color)
      out_cc.paint

      cards = range.collect { |i| @cards[i] }
      cards.each_with_index do |card, i|
        trimmed = trim_rounded(card.cairo_surface, trim, trim_radius)
        reflected = reflect(trimmed, reflect_offset, reflect_percent, reflect_strength)
        perspectived = perspective(reflected, scale, face_right)
        out_cc.set_source(perspectived, margin + i * perspectived.width * offset, margin)
        out_cc.paint
      end
      out_cc.target.write_to_png("#{dir}/#{file_to_save}")
    end

    # :nodoc:
    # @api private
    def trim_rounded(src, trim, radius)
      trim_cc = Cairo::Context.new(Cairo::ImageSurface.new(src.width-2.0*trim, src.height-2.0*trim))
      trim_cc.rounded_rectangle(0, 0, trim_cc.target.width, trim_cc.target.height, radius, radius)
      trim_cc.set_source(src, -1 * trim, -1 * trim)
      trim_cc.clip
      trim_cc.paint
      return trim_cc.target
    end

    # :nodoc:
    # @api private
    def reflect(src, roffset, rpercent, rstrength)
      tmp_cc = Cairo::Context.new(Cairo::ImageSurface.new(src.width, src.height * (1.0 + rpercent) + roffset))
      tmp_cc.set_source(src, 0, 0)
      tmp_cc.paint
      # Flip affine magic from: http://cairographics.org/matrix_transform/
      matrix = Cairo::Matrix.new(1, 0, 0, -1, 0, 2 * src.height + roffset)
      tmp_cc.transform(matrix) # flips the coordinate system
      top_y    = src.height    # top of the reflection
      bottom_y = src.height * (1.0 - rpercent) + roffset # bottom of the reflection
      gradient = Cairo::LinearPattern.new(0,top_y, 0,bottom_y)
      gradient.add_color_stop_rgba(0.0, 0,0,0, rstrength) # start a little reflected
      gradient.add_color_stop_rgba(1.0, 0,0,0, 0.0)       # fade to nothing
      tmp_cc.set_source(src, 0, 0)
      tmp_cc.mask(gradient)
      return tmp_cc.target
    end

    def perspective(src, scale, face_right)
      dest_cxt = Cairo::Context.new(Cairo::ImageSurface.new(src.width * scale, src.height))
      in_thickness = 1 # Take strip 1 pixel-width at a time
      out_thickness = 3 # Scale it to 3 pixels wider to cover any gaps
      (0..src.width).step(in_thickness) do |i|
        percentage = i / src.width.to_f
        i = src.width - i if face_right
        factor = scale + (percentage * (1.0 - scale)) #linear interpolation
        dest_cxt.save
        dest_cxt.translate 0, src.height / 2.0 * (1.0 - factor)
        dest_cxt.scale factor * scale, factor
        dest_cxt.set_source src, 0, 0
        dest_cxt.rounded_rectangle i, 0, out_thickness, src.height, 0,0
        dest_cxt.fill
        dest_cxt.restore
      end
      return dest_cxt.target
    end

  end
end