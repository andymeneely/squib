module Squib
  class Deck

    # :nodoc:
    # @api private
    def render_sheet(range, batch, sheet)
      rotate = batch.rotate.any? true # either rotate all or none
      w,h,sheet_width,sheet_height = compute_dimensions(sheet, rotate)
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
                                rotate, batch.angle[i])
          cc.set_source(surface, x, y)
          cc.paint
          num_this_sheet += 1
          x += (w + sheet.gap) * (sheet.rtl ? -1 : 1)
          if num_this_sheet % sheet.columns == 0 # new row
            x = sheet.rtl ? rtl_start_x(sheet_width, sheet, w) : sheet.margin
            y += h + sheet.gap
          end
          bar.increment
        end
        cc.target.write_to_png(batch.full_filename(sheet_num))
      end
    end

    def compute_dimensions(sheet, rotate)
      w,h = rotate ? [@height,@width] : [@width,@height]
      w -= 2 * sheet.trim
      h -= 2 * sheet.trim
      sheet_width = (sheet.columns * (w + 2 * sheet.gap)) + (2 * sheet.margin)
      sheet_height = (sheet.rows * (h + 2 * sheet.gap)) + (2 * sheet.margin)
      return [w, h, sheet_width, sheet_height]
    end

    def rtl_start_x(sheet_width, sheet, w)
      return sheet_width - sheet.margin - sheet.gap - w
    end

    # Return a new Cairo::ImageSurface that is trimmed and rotated
    # from the original
    # :nodoc:
    # @api private
    def preprocess(surface, trim, w, h, rotate, angle)
      if trim > 0 || rotate
        tmp = Cairo::ImageSurface.new(w, h)
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
