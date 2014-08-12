module Squib
  class Card

    # :nodoc:
    # @api private 
    def background(color)
      use_cairo do |cc|
        cc.set_source_color(color)
        cc.paint
      end
    end
      
  end
end