require 'squib/args/card_range'
require 'squib/args/paint'
require 'squib/args/scale_box'
require 'squib/args/transform'
require 'squib/args/input_file'
require 'squib/args/svg_special'

module Squib
  class Deck

    # Renders a png file at the given location.
    #
    # See {file:samples/image.rb samples/image.rb} and {file:samples/tgc-overlay.rb samples/tgc-overlay.rb} as examples.
    # @example
    #   png file: 'img.png', x: 50, y: 50
    #
    # @option opts range [Enumerable, :all] (:all) the range of cards over which this will be rendered. See {file:README.md#Specifying_Ranges Specifying Ranges}
    # @option opts file [String] ((empty)) file(s) to read in. If it's a single file, then it's use for every card in range. If the parameter is an Array of files, then each file is looked up for each card. If any of them are nil or '', nothing is done. See {file:README.md#Specifying_Files Specifying Files}. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    # @option opts x [Integer] (0) the x-coordinate to place. Supports Arrays, see {file:README#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts y [Integer] (0) the y-coordinate to place. Supports Arrays, see {file:README#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts width [Integer, :native, :scale, :deck] (:native) the pixel width that the image should scale to. :deck will scale to the deck width. :scale will use the height to scale and keep native the aspect ratio. Scaling PNGs is not recommended for professional-looking cards. When set to `:native`, uses the DPI and units of the loaded SVG document. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts height [Integer, :native, :scale, :deck] (:native) the pixel width that the image should scale to. :deck will scale to the deck height. :scale will use the width to scale and keep native the aspect ratio. Scaling PNGs is not recommended for professional-looking cards. When set to `:native`, uses the DPI and units of the loaded SVG document. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts layout [String, Symbol] (nil) entry in the layout to use as defaults for this command. See {file:README.md#Custom_Layouts Custom Layouts}. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    # @option opts alpha [Decimal] (1.0) the alpha-transparency percentage used to blend this image. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    # @option opts blend [:none, :multiply, :screen, :overlay, :darken, :lighten, :color_dodge, :color_burn, :hard_light, :soft_light, :difference, :exclusion, :hsl_hue, :hsl_saturation, :hsl_color, :hsl_luminosity] (:none) the composite blend operator used when applying this image. See Blend Modes at http://cairographics.org/operators. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    # @option opts angle [FixNum] (0) Rotation of the in radians. Note that this rotates around the upper-left corner, making the placement of x-y coordinates slightly tricky. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    # @option opts mask [String] (nil) If specified, the image will be used as a mask for the given color/gradient. Transparent pixels are ignored, opaque pixels are the given color. Note: the origin for gradient coordinates is at the given x,y, not at 0,0 as it is most other places.
    # @return [nil] Returns nil
    # @api public
    def png(opts = {})
      Dir.chdir(img_dir) do
        range = Args::CardRange.new(opts[:range], deck_size: size)
        paint = Args::Paint.new(custom_colors).load!(opts, expand_by: size, layout: layout)
        box   = Args::ScaleBox.new(self).load!(opts, expand_by: size, layout: layout, dpi: dpi)
        trans = Args::Transform.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
        ifile = Args::InputFile.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
        @progress_bar.start('Loading PNG(s)', range.size) do |bar|
          range.each do |i|
            @cards[i].png(ifile[i].file, box[i], paint[i], trans[i])
            bar.increment
          end
        end
      end
    end

    # Renders an entire svg file at the given location. Uses the SVG-specified units and DPI to determine the pixel width and height.  If neither data nor file are specified for a given card, this method does nothing.
    #
    # See {file:samples/load-images.rb samples/load-images.rb} and {file:samples/tgc-overlay.rb samples/tgc-overlay.rb} as examples.
    #
    # Note: if alpha transparency is desired, set that in the SVG.
    #
    # @example
    #   svg range: 1..2, file: 'icon.svg', id: '#stone', x: 50, y:50
    #
    # @option opts range [Enumerable, :all] (:all) the range of cards over which this will be rendered. See {file:README.md#Specifying_Ranges Specifying Ranges}
    # @option opts file [String] ('') file(s) to read in. If it's a single file, then it's use for every card in range. If the parameter is an Array of files, then each file is looked up for each card. If any of them are nil or '', nothing is done. See {file:README.md#Specifying_Files Specifying Files}. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    # @option opts data [String] (nil) render from an SVG XML string. Overrides file if both are specified (a warning is shown) . If it's a single file, then it's use for every card in range. If the parameter is an Array of files, then each file is looked up for each card. If any of them are nil or '', nothing is done. See {file:README.md#Specifying_Files Specifying Files}. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}.
    # @option opts id [String] (nil) if set, then only render the SVG element with the given id. Prefix '#' is optional. Note: the x-y coordinates are still relative to the SVG document's page. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    # @option opts force_id [Boolean] (false) if set, then this svg will not be rendered at all if the id is empty or nil. If not set, the entire SVG is rendered. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    # @option opts x [Integer] (0) the x-coordinate to place. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts y [Integer] (0) the y-coordinate to place. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts width [Integer] (:native) the pixel width that the image should scale to. :deck will scale to the deck height. :scale will use the width to scale and keep native the aspect ratio. SVG scaling is done with vectors, so the scaling should be smooth. When set to `:native`, uses the DPI and units of the loaded SVG document. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts height [Integer] (:native) the pixel width that the image should scale to. :deck will scale to the deck height. :scale will use the width to scale and keep native the aspect ratio. SVG scaling is done with vectors, so the scaling should be smooth. When set to `:native`, uses the DPI and units of the loaded SVG document. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts layout [String, Symbol] (nil) entry in the layout to use as defaults for this command. See {file:README.md#Custom_Layouts Custom Layouts}. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    # @option opts blend [:none, :multiply, :screen, :overlay, :darken, :lighten, :color_dodge, :color_burn, :hard_light, :soft_light, :difference, :exclusion, :hsl_hue, :hsl_saturation, :hsl_color, :hsl_luminosity] (:none) the composite blend operator used when applying this image. See Blend Modes at http://cairographics.org/operators. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    # @option opts angle [FixNum] (0) Rotation of the in radians. Note that this rotates around the upper-left corner, making the placement of x-y coordinates slightly tricky. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    # @option opts mask [String] (nil) If specified, the image will be used as a mask for the given color/gradient. Transparent pixels are ignored, opaque pixels are the given color. Note: the origin for gradient coordinates is at the given x,y, not at 0,0 as it is most other places.
    # @return [nil] Returns nil
    # @api public
    def svg(opts = {})
      Dir.chdir(img_dir) do
        range = Args::CardRange.new(opts[:range], deck_size: size)
        paint = Args::Paint.new(custom_colors).load!(opts, expand_by: size, layout: layout)
        box   = Args::ScaleBox.new(self).load!(opts, expand_by: size, layout: layout, dpi: dpi)
        trans = Args::Transform.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
        ifile = Args::InputFile.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
        svg_args = Args::SvgSpecial.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
        @progress_bar.start('Loading SVG(s)', range.size) do |bar|
          range.each do |i|
            if svg_args.render?(i)
              @cards[i].svg(ifile[i].file, svg_args[i], box[i], paint[i], trans[i])
            end
            bar.increment
          end
        end
      end
    end

  end
end
