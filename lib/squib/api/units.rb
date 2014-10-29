module Squib
  class Deck

    # Given inches, returns the number of pixels according to the deck's DPI.
    #
    # @example
    #   inches(2.5) # 750 (for default Deck::dpi of 300)
    #
    # @param n [Decimal], the number of inches
    # @return [Decimal] the number of pixels, according to the deck's DPI
    # @api public
    def inches(n)
      @dpi * n
    end

  end
end
