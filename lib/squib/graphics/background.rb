module Squib
  class Card

    # :nodoc:
    # @api private
    def background(color)
      use_cairo do |cc|
        cc.set_source_squibcolor(color)
        cc.paint
      end
    end

  end
end
