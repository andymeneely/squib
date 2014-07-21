module Squib
  class Deck

    # Given inches, returns the number of pixels according to the deck's DPI.
    #
    # @param [Decimal] n, the number of inches
    # @return [Decimal] the number of pixels, according to the deck's DPI
    # @api public
    def inches(n)
      @dpi * n
    end

  end
end