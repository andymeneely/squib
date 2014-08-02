module Squib
  class Deck

    # Renders a png file at the given location.
    #
    # See {file:samples/image.rb samples/image.rb} and {file:samples/tgc-overlay.rb samples/tgc-overlay.rb} as examples.
    # Note: scaling not currently supported for PNGs.
    # @example
    #   png file: 'img.png', x: 50, y: 50
    #
    # @option opts range [Enumerable, :all] (:all) the range of cards over which this will be rendered. See {file:API.md#label-Specifying+Ranges Specifying Ranges}
    # @option opts file [String, Array] ('') file(s) to read in. If it's a single file, then it's use for every card in range. If the parameter is an Array of files, then each file is looked up for each card. If any of them are nil or '', nothing is done. See {file:API.md#Specifying+Files Specifying Files}
    # @option opts x [Integer] (0) the x-coordinate to place
    # @option opts y [Integer] (0) the y-coordinate to place
    # @option opts layout [String, Symbol] (nil) entry in the layout to use as defaults for this command. See {file:API.md#label-Custom+Layouts Custom Layouts}
    # @option opts alpha [Decimal] (1.0) the alpha-transparency percentage used to blend this image
    # @return [nil] Returns nil
    # @api public
    def png(opts = {})
      opts = needs(opts, [:range, :files, :x, :y, :alpha, :layout])
      @progress_bar.start("Loading PNGs #{location(opts)}", opts[:range].size) do |bar|
        opts[:range].each do |i| 
          @cards[i].png(opts[:file][i], opts[:x], opts[:y], opts[:alpha]) 
          bar.increment
        end
      end
    end

    # Renders an entire svg file at the given location. Uses the SVG-specified units and DPI to determine the pixel width and height.
    #
    # See {file:samples/load-images.rb samples/load-images.rb} and {file:samples/tgc-overlay.rb samples/tgc-overlay.rb} as examples.
    # @example 
    #   svg 1..2, 'icon.svg', '#stone', x: 50, y:50
    #
    # @option opts range [Enumerable, :all] (:all) the range of cards over which this will be rendered. See {file:API.md#label-Specifying+Ranges Specifying Ranges}
    # @option opts file [String, Array] ('') file(s) to read in. If it's a single file, then it's use for every card in range. If the parameter is an Array of files, then each file is looked up for each card. If any of them are nil or '', nothing is done. See {file:API.md#Specifying+Files Specifying Files}
    # @option opts id [String] (nil) if set, then only render the SVG element with the given id. Prefix '#' is optional. Note: the x-y coordinates are still relative to the SVG document's page
    # @option opts x [Integer] (0) the x-coordinate to place
    # @option opts y [Integer] (0) the y-coordinate to place
    # @option opts width [Integer] (:native) the pixel width that the image should scale to. SVG scaling is done with vectors, so the scaling should be smooth. When set to `:native`, uses the DPI and units of the loaded SVG document.
    # @option opts height [Integer] (:native) the pixel width that the image should scale to. SVG scaling is done with vectors, so the scaling should be smooth. When set to `:native`, uses the DPI and units of the loaded SVG document.
    # @option opts layout [String, Symbol] (nil) entry in the layout to use as defaults for this command. See {file:API.md#label-Custom+Layouts Custom Layouts}
    # @return [nil] Returns nil
    # @api public
    def svg(opts = {})
      p = needs(opts,[:range, :files, :svgid, :x, :y, :width, :height, :layout])
      @progress_bar.start("Loading SVGs #{location(opts)}", p[:range].size) do |bar|
        p[:range].each do |i| 
          @cards[i].svg(p[:file][i], p[:id], p[:x], p[:y], p[:width], p[:height]) 
          bar.increment
        end
      end
    end

  end
end