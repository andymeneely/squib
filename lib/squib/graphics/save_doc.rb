module Squib
  class Deck

    def save_pdf(opts = {})
      p = needs(opts, [:file_to_save, :prefix, :margin, :gap, :trim])
      width = 11 * @dpi ; height = 8.5 * @dpi #TODO: allow this to be specified too
      cc = Cairo::Context.new(Cairo::PDFSurface.new("#{dir}/#{file}", width, height))
      x = p[:margin] ; y = p[:margin]
      @cards.each_with_index do |card, i|
        surface = trim(card.cairo_surface, p[:trim], @width, @height)
        cc.set_source(surface, x, y)
        cc.paint
        x += surface.width + gap
        if x > (width - surface.width - margin)
          x = p[:margin]
          y += surface.height + p[:gap]
          if y > (height - surface.height - margin)
            x = p[:margin] ; y = p[:margin]
            cc.show_page #next page
          end
        end
      end
    end

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