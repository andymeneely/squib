module Squib
  class Deck

    # :nodoc:
    # @api private
    def render_sheet(range, batch, sheet)
      w,h,sheet_width,sheet_height = compute_dimensions(sheet, batch)
      cc = Cairo::Context.new(Cairo::ImageSurface.new(sheet_width, sheet_height))
      num_this_sheet = 0
      sheet_num = 0
      y = sheet.margin
      x = sheet.rtl ? (sheet_width - sheet.margin - sheet.gap - w) : sheet.margin
      @progress_bar.start("Saving PNG sheet to #{batch.summary}", @cards.size + 1) do |bar|
        range.each do |i|
          if num_this_sheet >= (sheet.columns * sheet.rows) # new sheet
            filename = batch.full_filename(sheet_num)
            cc.target.write_to_png(filename)
            new_sheet = false
            num_this_sheet = 0
            sheet_num += 1
            y = sheet.margin
            x = sheet.rtl ? (sheet_width - sheet.margin - sheet.gap - w) : sheet.margin
            cc = Cairo::Context.new(Cairo::ImageSurface.new(sheet_width, sheet_height))
          end
          surface = preprocess(@cards[i].cairo_surface,
                                sheet.trim, w, h,
                                batch.rotate[i], batch.angle[i])
          cc.set_source(surface, x, y)
          cc.paint
          num_this_sheet += 1
          x += (surface.width + sheet.gap) * (sheet.rtl ? -1 : 1)
          if num_this_sheet % sheet.columns == 0 # new row
            x = sheet.rtl ? (sheet_width - sheet.margin - sheet.gap - w) : sheet.margin
            y += surface.height + sheet.gap
          end

          bar.increment
        end
        cc.target.write_to_png(batch.full_filename(sheet_num))
      end
    end

    def compute_dimensions(sheet, batch)
      w,h = batch.rotate ? [@height,@width] : [@width,@height]
      sheet_width = (sheet.columns * (w + 2 * sheet.gap - 2 * sheet.trim)) + (2 * sheet.margin)
      sheet_height = (sheet.rows * (h + 2 * sheet.gap - 2 * sheet.trim)) + (2 * sheet.margin)
      return [w, h, sheet_width, sheet_height]
    end

    # Return a new Cairo::ImageSurface that is trimmed and rotated
    # from the original
    #
    # @param surface The surface to trim
    # @param trim The number of pixels around the edge to trim
    # @param width The width of the surface prior to the trim
    # @param height The height of the surface prior to the trim
    # :nodoc:
    # @api private
    def preprocess(surface, trim, w, h, rotate, angle)
      if trim > 0 || rotate
        tmp = Cairo::ImageSurface.new(w - 2 * trim, h - 2 * trim)
        cc = Cairo::Context.new(tmp)
        if rotate
            cc.translate w * 0.5, h * 0.5
            cc.rotate angle
            cc.translate h * -0.5, w * -0.5
          end
        cc.set_source(surface, -1 * trim, -1 * trim)
        cc.paint
        surface = tmp
      end
      surface
    end

  end
end
