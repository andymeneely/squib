module Squib
  class Deck
    
    # Renders a png file at the given location.
    #   See {file:samples/image.rb samples/image.rb} and {file:samples/tgc-overlay.rb samples/tgc-overlay.rb} as examples.
    #   Note: scaling not currently supported for PNGs.
    #
    # @param range: the range of cards over which this will be rendered. See {file:API.md#label-Specifying+Ranges Specifying Ranges}
    # @param file: the . See {file:API.md#Specifying+Files Specifying Files}
    # @param x: the x-coordinate to place
    # @param y: the y-coordinate to place
    # @param alpha: the alpha-transparency percentage used to blend this image
    # @api public
    def png(range: :all, file: nil, x: 0, y: 0, alpha: 1.0)
      range = rangeify(range)
      file = fileify(file)
      range.each{ |i| @cards[i].png(file, x, y, alpha) }
    end

    # Renders an entire svg file at the given location. Uses the SVG-specified units and DPI to determine the pixel width and height.
    #   See {file:samples/load-images.rb samples/load-images.rb} and {file:samples/tgc-overlay.rb samples/tgc-overlay.rb} as examples.
    #
    # @param range: the range of cards over which this will be rendered. See {file:API.md#label-Specifying+Ranges Specifying Ranges}
    # @param file: the svg file to render. See {file:API.md#Specifying+Files Specifying Files}
    # @param id: if specified, only render the SVG element with the supplied id. Otherwise, render the entire SVG file
    # @param x: the x-coordinate to place
    # @param y: the y-coordinate to place
    # @param width: the pixel width that the image should scale to. SVG scaling is done with vectors, so the scaling should be smooth. When set to `:native`, uses the DPI and units of the loaded SVG document.
    # @param height: the pixel width that the image should scale to. SVG scaling is done with vectors, so the scaling should be smooth. When set to `:native`, uses the DPI and units of the loaded SVG document.
    # @return [nil]
    # @api public
    def svg(range: :all, file: nil, id: nil, x: 0, y: 0, width: :native, height: :native)
      range = rangeify(range)
      file = fileify(file)
      id = idify(id)
      range.each{ |i| @cards[i].svg(file, id, x, y, width, height) }
    end

  end
end