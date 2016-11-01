module Squib
  class Deck

    # :nodoc:
    # @api private
    def render_sheet(range, batch, sheet)
      sheet_width = (sheet.columns * (@width + 2 * sheet.gap - 2 * sheet.trim)) + (2 * sheet.margin)
      sheet_height = (sheet.rows * (@height + 2 * sheet.gap - 2 * sheet.trim)) + (2 * sheet.margin)
      cc = Cairo::Context.new(Cairo::ImageSurface.new(sheet_width, sheet_height))
      num_this_sheet = 0
      sheet_num = 0
      x, y = sheet.margin, sheet.margin
      @progress_bar.start("Saving PNG sheet to #{batch.summary}", @cards.size + 1) do |bar|
        range.each do |i|
          if num_this_sheet >= (sheet.columns * sheet.rows) # new sheet
            filename = batch.full_filename(sheet_num)
            cc.target.write_to_png(filename)
            new_sheet = false
            num_this_sheet = 0
            sheet_num += 1
            x, y = sheet.margin, sheet.margin
            cc = Cairo::Context.new(Cairo::ImageSurface.new(sheet_width, sheet_height))
          end
          surface = trim(@cards[i].cairo_surface, sheet.trim, @width, @height)
          cc.set_source(surface, x, y)
          cc.paint
          num_this_sheet += 1
          x += surface.width + sheet.gap
          if num_this_sheet % sheet.columns == 0 # new row
            x = sheet.margin
            y += surface.height + sheet.gap
          end
          bar.increment
        end
        cc.target.write_to_png(batch.full_filename(sheet_num))
      end
    end

    # Return a new Cairo::ImageSurface that is trimmed from the original
    #
    # @param surface The surface to trim
    # @param trim The number of pixels around the edge to trim
    # @param width The width of the surface prior to the trim
    # @param height The height of the surface prior to the trim
    # :nodoc:
    # @api private
    def trim(surface, trim, width, height)
      if trim > 0
        tmp = Cairo::ImageSurface.new(width - 2 * trim, height - 2 * trim)
        cc = Cairo::Context.new(tmp)
        cc.set_source(surface, -1 * trim, -1 * trim)
        cc.paint
        surface = tmp
      end
      surface
    end

  end
end
