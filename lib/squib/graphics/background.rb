module Squib
  class Card

    def background(color)
      cc = cairo_context
      cc.set_source_rgb(*color)
      cc.paint
    end
      
  end
end