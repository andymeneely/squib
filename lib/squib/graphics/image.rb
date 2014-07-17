module Squib
  class Card

    def png(file, x, y)
      cc = cairo_context
      png = Cairo::ImageSurface.from_png(file)
      cc.set_source(png, x, y)
      cc.paint
    end

  end
end