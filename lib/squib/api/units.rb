module Squib
  class Deck

    # Given inches, returns the number of pixels according to the deck's DPI.
    # 
    # @example inches(2.5) # 750px for 300 dpi
    # @param [Decimal] n, the number of inches
    # @return [Decimal] the number of pixels, according to the deck's DPI
    # @api public
    def inches(n)
      @dpi * n
    end

  end
end