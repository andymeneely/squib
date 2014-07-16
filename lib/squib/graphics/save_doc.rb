module Squib
  class Deck

    def save_pdf
      #paper is 8.5x11
      # PDF points are 1/72 of an inch
      width = 8.5 * 72
      height = 11 * 72
      cc = Cairo::Context.new(Cairo::PDFSurface.new('_img/deck.pdf', width, height))
      x = 10
      y = 10
      @cards.each_with_index do |card, i|
        cc.move_to(x,y)
        x += 825*i
        cc.set_source(card.cairo_surface, 0, 300)
        cc.paint
      end
    end

  end
end