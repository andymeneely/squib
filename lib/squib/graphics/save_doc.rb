module Squib
  class Deck

    def save_pdf(file: 'deck.pdf', dir: '_output', margin: 75, gap: 0, trim: 0)
      dir = dirify(dir, allow_create: true)
      width = 11 * @dpi ; height = 8.5 * @dpi #TODO: allow this to be specified too
      cc = Cairo::Context.new(Cairo::PDFSurface.new("#{dir}/#{file}", width, height))
      x = margin ; y = margin
      @cards.each_with_index do |card, i|
        surface = trim(card.cairo_surface, trim, @width, @height)
        cc.set_source(surface, x, y)
        cc.paint
        x += surface.width + gap
        if x > (width - surface.width - margin)
          x = margin 
          y += surface.height + gap
          if y > (height - surface.height - margin)
            x = margin ; y = margin
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