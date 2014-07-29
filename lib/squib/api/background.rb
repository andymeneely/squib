module Squib
  class Deck
    # Fills the background with the given color 
    # @example
    #   background color: :white
    #
    # @option range [Enumerable] (:all) the range of cards over which this will be rendered. See {file:API.md#label-Specifying+Ranges Specifying Ranges}
    # @option color [String] (:black) the color the font will render to. See {file:API.md#label-Specifying+Colors Specifying Colors}
    # @return [nil] nothing
    # @api public
    def background(opts = {})
      opts = needs(opts,[:range, :color])
      opts[:range].each { |i| @cards[i].background(opts[:color]) }
    end
      
  end
end