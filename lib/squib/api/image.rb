module Squib
  class Deck
    
    # Renders a png file at the given location.
    #   See {file:samples/image.rb samples/image.rb} and {file:samples/tgc-overlay.rb samples/tgc-overlay.rb} as examples.
    #   Note: scaling not currently supported.
    #
    # @param range: the range of cards over which this will be rendered. See {file:API.md#label-Specifying+Ranges Specifying Ranges}
    # @param file: the . See {file:API.md#Specifying+Files Specifying Files}
    # @param x: the x-coordinate to place
    # @param y: the y-coordinate to place
    # @param alpha: the alpha-transparency percentage used to blend this image
    def png(range: :all, file: nil, x: 0, y: 0, alpha: 1.0)
      range = rangeify(range)
      file = fileify(file)
      range.each{ |i| @cards[i].png(file, x, y, alpha) }
    end

    # Renders an entire svg file at the given location. Uses the SVG-specified units and DPI to determine the pixel width and height.
    #   See {file:samples/image.rb samples/image.rb} and {file:samples/tgc-overlay.rb samples/tgc-overlay.rb} as examples.
    #   Note: scaling not currently supported.
    #
    # @param range: the range of cards over which this will be rendered. See {file:API.md#label-Specifying+Ranges Specifying Ranges}
    # @param file: the . See {file:API.md#Specifying+Files Specifying Files}
    # @param x: the x-coordinate to place
    # @param y: the y-coordinate to place
    def svg(range: :all, file: nil, x: 0, y: 0)
      range = rangeify(range)
      file = fileify(file)
      range.each{ |i| @cards[i].svg(file, x, y) }
    end

  end
end