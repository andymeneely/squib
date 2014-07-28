module Squib
  class Deck
    
    # Renders a png file at the given location.
    #   See {file:samples/image.rb samples/image.rb} and {file:samples/tgc-overlay.rb samples/tgc-overlay.rb} as examples.
    #   Note: scaling not currently supported for PNGs.
    #
    # @param range: the range of cards over which this will be rendered. See {file:API.md#label-Specifying+Ranges Specifying Ranges}
    # @param file: file(s) to read in. If it's a single file, then it's use for every card. If the parameter is an Array of files, then each file is looked up for each card. See {file:API.md#Specifying+Files Specifying Files}
    # @param x: the x-coordinate to place
    # @param y: the y-coordinate to place
    # @param alpha: the alpha-transparency percentage used to blend this image
    # @return [nil] intended to be void
    # @api public
    def png(opts = {})
      opts = needs(opts, [:range, :files, :x, :y, :alpha])
      opts[:range].each do |i| 
        @cards[i].png(opts[:file][i], opts[:x], opts[:y], opts[:alpha]) 
      end
    end

    # Renders an entire svg file at the given location. Uses the SVG-specified units and DPI to determine the pixel width and height.
    # @example 
    #   svg 1..2, 'icon.svg', '#stone', x: 50, y:50
    #
    # See {file:samples/load-images.rb samples/load-images.rb} and {file:samples/tgc-overlay.rb samples/tgc-overlay.rb} as examples.
    #
    # @param range: the range of cards over which this will be rendered. See {file:API.md#label-Specifying+Ranges Specifying Ranges}
    # @param file: the svg file to render. See {file:API.md#Specifying+Files Specifying Files}
    # @param id: if specified, only render the SVG element with the supplied id. Otherwise, render the entire SVG file
    # @param x: the x-coordinate to place
    # @param y: the y-coordinate to place
    # @param width: the pixel width that the image should scale to. SVG scaling is done with vectors, so the scaling should be smooth. When set to `:native`, uses the DPI and units of the loaded SVG document.
    # @param height: the pixel width that the image should scale to. SVG scaling is done with vectors, so the scaling should be smooth. When set to `:native`, uses the DPI and units of the loaded SVG document.
    # @return [nil] essentially a void method
    # @api public
    def svg(opts = {})
      p = needs(opts,[:range, :files, :svgid, :x, :y, :width, :height])
      p[:range].each do |i| 
        @cards[i].svg(p[:file][i], p[:id], p[:x], p[:y], p[:width], p[:height]) 
      end
    end

  end
end