module Squib
  class Deck
    # Fills the background with the given color 
    #
    # @param range: the range of cards over which this will be rendered. See {file:API.md#label-Specifying+Ranges Specifying Ranges}
    # @param color: the color the font will render to. See {file:API.md#label-Specifying+Colors Specifying Colors}
    # @api public
    def background(range: :all, color: :white)
      range = rangeify(range)
      color = colorify(color)
      range.each { |i| @cards[i].background(color) }
    end
      
  end
end