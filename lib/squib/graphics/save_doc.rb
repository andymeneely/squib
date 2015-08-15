module Squib
  class Deck

    # :nodoc:
    # @api private
    def render_pdf(range, sheet)
      file         = "#{sheet.dir}/#{sheet.file}"
      cc           = Cairo::Context.new(Cairo::PDFSurface.new(file, sheet.width * 72.0 / @dpi, sheet.height * 72.0 / @dpi))
      cc.scale(72.0 / @dpi, 72.0 / @dpi) # for bug #62
      x, y         = sheet.margin, sheet.margin
      card_width   = @width  - 2 * sheet.trim
      card_height  = @height - 2 * sheet.trim
      @progress_bar.start("Saving PDF to #{file}", range.size) do |bar|
        range.each do |i|
          card = @cards[i]
          cc.translate(x,y)
          cc.rectangle(sheet.trim, sheet.trim, card_width, card_height)
          cc.clip
          case card.backend.downcase.to_sym
          when :memory
            cc.set_source(card.cairo_surface, 0, 0)
            cc.paint
          when :svg
            card.cairo_surface.finish
            cc.save
            cc.scale(0.8,0.8) # I really don't know why I needed to do this at all. But 0.8 is the magic number to get this to scale right
            cc.render_rsvg_handle(RSVG::Handle.new_from_file(card.svgfile), nil)
            cc.restore
          else
            abort "No such back end supported for save_pdf: #{backend}"
          end
          bar.increment
          cc.reset_clip
          cc.translate(-x,-y)
          x += card.width + sheet.gap - 2*sheet.trim
          if x > (sheet.width - card_width - sheet.margin)
            x = sheet.margin
            y += card.height + sheet.gap - 2*sheet.trim
            if y > (sheet.height - card_height - sheet.margin)
              cc.show_page # next page
              x,y = sheet.margin,sheet.margin
            end
          end
        end
      end
    end

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
        tmp = Cairo::ImageSurface.new(width-2*trim, height-2*trim)
        cc = Cairo::Context.new(tmp)
        cc.set_source(surface,-1*trim, -1*trim)
        cc.paint
        surface = tmp
      end
      surface
    end

  end
end
