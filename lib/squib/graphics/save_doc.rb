module Squib
  class Deck

    # Lays out the cards in range and renders a PDF
    #
    # @example
    #   save_pdf file: 'deck.pdf', margin: 75, gap: 5, trim: 37
    #
    # @option opts file [String] the name of the PDF file to save. See {file:README.md#Specifying_Files Specifying Files}
    # @option opts dir [String] (_output) the directory to save to. Created if it doesn't exist.
    # @option opts margin [Integer] (75) the margin around the outside of the page
    # @option opts gap [Integer] (0) the space in pixels between the cards
    # @option opts trim [Integer] (0) the space around the edge of each card to trim (e.g. to cut off the bleed margin for print-and-play)
    # @return [nil]
    # @api public
    def save_pdf(opts = {})
      p = needs(opts, [:file_to_save, :creatable_dir, :margin, :gap, :trim])
      width = 11 * @dpi ; height = 8.5 * @dpi #TODO: allow this to be specified too
      cc = Cairo::Context.new(Cairo::PDFSurface.new("#{p[:dir]}/#{p[:file]}", width, height))
      x = p[:margin] ; y = p[:margin]

      @progress_bar.start("Saving PDF to #{p[:dir]}/#{p[:file]}", p[:range].size) do |bar|
        @cards.each_with_index do |card, i|
          surface = trim(card.cairo_surface, p[:trim], @width, @height)
          cc.set_source(surface, x, y)
          cc.paint
          bar.increment
          x += surface.width + p[:gap]
          if x > (width - surface.width - p[:margin])
            x = p[:margin]
            y += surface.height + p[:gap]
            if y > (height - surface.height - p[:margin])
              x = p[:margin] ; y = p[:margin]
              cc.show_page #next page
            end
          end
        end
    end
    end

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