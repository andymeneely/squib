require_relative '../constants'

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
      @dpi * n.to_f
    end

    # Given cm, returns the number of pixels according to the deck's DPI.
    #
    # @example
    #   cm(1) # 750 (for default Deck::dpi of 300)
    #
    # @param n [Decimal], the number of centimeters
    # @return [Decimal] the number of pixels, according to the deck's DPI
    # @api public
    def cm(n)
      @dpi * Squib::INCHES_IN_CM * n.to_f
    end

  end
end
