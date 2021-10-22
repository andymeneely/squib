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
      x = sheet.rtl ? rtl_start_x(sheet_width, sheet, w) : sheet.margin
      @progress_bar.start("Saving PNG sheet to #{batch.summary}", @cards.size + 1) do |bar|
        range.each do |i|
          if num_this_sheet >= (sheet.columns * sheet.rows) # new sheet
            filename = batch.full_filename(sheet_num)
            cc.target.write_to_png(filename)
            new_sheet = false
            num_this_sheet = 0
            sheet_num += 1
            y = sheet.margin
            x = sheet.rtl ? rtl_start_x(sheet_width, sheet, w) : sheet.margin
            cc = Cairo::Context.new(Cairo::ImageSurface.new(sheet_width, sheet_height))
          end
          surface = preprocess(@cards[i].cairo_surface,
                                sheet.trim, w, h,
                                batch.rotate[i], batch.angle[i])
          cc.set_source(surface, x, y)
          cc.paint
          num_this_sheet += 1
          x += (w + sheet.gap - 2 * sheet.trim) * (sheet.rtl ? -1 : 1)
          if num_this_sheet % sheet.columns == 0 # new row
            x = sheet.rtl ? rtl_start_x(sheet_width, sheet, w) : sheet.margin
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

    def rtl_start_x(sheet_width, sheet, w)
      return sheet_width - sheet.margin - sheet.gap - w + 2 * sheet.trim
    end

    # Return a new Cairo::ImageSurface that is trimmed and rotated
    # from the original
    # :nodoc:
    # @api private
    def preprocess(surface, trim, w, h, rotate, angle)
      trimmed_w = w - 2 * trim
      trimmed_h = h - 2 * trim
      if trim > 0 || rotate
        tmp = Cairo::ImageSurface.new(trimmed_w, trimmed_h)
        cc = Cairo::Context.new(tmp)
        if rotate
            cc.translate trimmed_w * 0.5, trimmed_h * 0.5
            cc.rotate angle
            cc.translate trimmed_h * -0.5, trimmed_w * -0.5
          end
        cc.set_source(surface, -1 * trim, -1 * trim)
        cc.paint
        surface = tmp
      end
      surface
    end

  end
end
