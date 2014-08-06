module Squib
  class Deck
    # Fills the background with the given color 
    # @example
    #   background color: :white
    #
    # @option opts range [Enumerable] (:all) the range of cards over which this will be rendered. See {file:README.md#Specifying_Ranges Specifying Ranges}
    # @option opts color [String] (:black) the color the font will render to. See {file:README.md#Specifying_Colors Specifying Colors}
    # @return [nil] nothing
    # @api public
    def background(opts = {})
      opts = needs(opts,[:range, :color])
      opts[:range].each { |i| @cards[i].background(opts[:color]) }
    end
      
  end
end