require 'squib/args/box'
require 'squib/args/card_range'
require 'squib/args/embed_adjust'
require 'squib/args/embed_key'
require 'squib/args/input_file'
require 'squib/args/paint'
require 'squib/args/transform'

module Squib
  class TextEmbed
    # :nodoc:
    # @api private
    attr_reader :rules

    # :nodoc:
    # @api private
    def initialize(deck_size, custom_colors, layout, dpi, img_dir)
      @deck_size     = deck_size
      @custom_colors = custom_colors
      @layout        = layout
      @dpi           = dpi
      @img_dir       = img_dir
      @rules = {} # store an array of options for later usage
    end

    # Context object for embedding an svg icon within text
    #
    # @option opts key [String] ('*') the string to replace with the graphic. Can be multiple letters, e.g. ':tool:'
    # @option opts file [String] ('') file(s) to read in. If it's a single file, then it's use for every card in range. If the parameter is an Array of files, then each file is looked up for each card. If any of them are nil or '', nothing is done. See {file:README.md#Specifying_Files Specifying Files}. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    # @option opts id [String] (nil) if set, then only render the SVG element with the given id. Prefix '#' is optional. Note: the x-y coordinates are still relative to the SVG document's page. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    # @option opts force_id [Boolean] (false) if set, then this svg will not be rendered at all if the id is empty or nil. If not set, the entire SVG is rendered. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    # @option opts layout [String, Symbol] (nil) entry in the layout to use as defaults for this command. See {file:README.md#Custom_Layouts Custom Layouts}. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    # @option opts width [Integer] (:native) the width of the image rendered.
    # @option opts height [Integer] (:native) the height the height of the image rendered.
    # @option opts dx [Integer] (0) "delta x", or adjust the icon horizontally by x pixels
    # @option opts dy [Integer] (0) "delta y", or adjust the icon vertically by y pixels
    # @option opts alpha [Decimal] (1.0) the alpha-transparency percentage used to blend this image. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    # @option opts blend [:none, :multiply, :screen, :overlay, :darken, :lighten, :color_dodge, :color_burn, :hard_light, :soft_light, :difference, :exclusion, :hsl_hue, :hsl_saturation, :hsl_color, :hsl_luminosity] (:none) the composite blend operator used when applying this image. See Blend Modes at http://cairographics.org/operators. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    # @option opts angle [FixNum] (0) Rotation of the in radians. Note that this rotates around the upper-left corner, making the placement of x-y coordinates slightly tricky. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    # @api public
    def svg(opts = {})
      key   = Args::EmbedKey.new.validate_key(opts[:key])
      range = Args::CardRange.new(opts[:range], deck_size: @deck_size)
      paint = Args::Paint.new(@custom_colors).load!(opts, expand_by: @deck_size, layout: @layout)
      box   = Args::Box.new(self, {width: :native, height: :native}).load!(opts, expand_by: @deck_size, layout: @layout, dpi: @dpi)
      adjust= Args::EmbedAdjust.new.load!(opts, expand_by: @deck_size, layout: @layout, dpi: @dpi)
      trans = Args::Transform.new.load!(opts, expand_by: @deck_size, layout: @layout, dpi: @dpi)
      ifile = Args::InputFile.new.load!(opts, expand_by: @deck_size, layout: @layout, dpi: @dpi)
      svg_args = Args::SvgSpecial.new.load!(opts, expand_by: @deck_size, layout: @layout, dpi: @dpi)
      rule  = { type: :png, file: ifile, box: box, paint: paint, trans: trans, adjust: adjust }
      rule[:draw] = Proc.new do |card, x, y|
        i = card.index
        b = box[i]
        b.x, b.y = x, y
        Dir.chdir(@img_dir) do
          card.svg(ifile[i].file, svg_args[i], b, paint[i], trans[i])
        end
      end
      @rules[key] = rule
    end

    # Context object for embedding a png within text
    #
    # @option opts key [String] ('*') the string to replace with the graphic. Can be multiple letters, e.g. ':tool:'
    # @option opts file [String] ('') file(s) to read in. If it's a single file, then it's use for every card in range. If the parameter is an Array of files, then each file is looked up for each card. If any of them are nil or '', nothing is done. See {file:README.md#Specifying_Files Specifying Files}. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    # @option opts layout [String, Symbol] (nil) entry in the layout to use as defaults for this command. See {file:README.md#Custom_Layouts Custom Layouts}. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    # @option opts width [Fixnum] (:native) the width of the image rendered
    # @option opts height [Fixnum] (:native) the height of the image rendered
    # @option opts dx [Integer] (0) "delta x", or adjust the icon horizontally by x pixels
    # @option opts dy [Integer] (0) "delta y", or adjust the icon vertically by y pixels
    # @option opts alpha [Decimal] (1.0) the alpha-transparency percentage used to blend this image. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    # @option opts blend [:none, :multiply, :screen, :overlay, :darken, :lighten, :color_dodge, :color_burn, :hard_light, :soft_light, :difference, :exclusion, :hsl_hue, :hsl_saturation, :hsl_color, :hsl_luminosity] (:none) the composite blend operator used when applying this image. See Blend Modes at http://cairographics.org/operators. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    # @option opts angle [FixNum] (0) Rotation of the in radians. Note that this rotates around the upper-left corner, making the placement of x-y coordinates slightly tricky. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    # @api public
    def png(opts = {})
      key   = Args::EmbedKey.new.validate_key(opts[:key])
      range = Args::CardRange.new(opts[:range], deck_size: @deck_size)
      paint = Args::Paint.new(@custom_colors).load!(opts, expand_by: @deck_size, layout: @layout)
      box   = Args::Box.new(self, {width: :native, height: :native}).load!(opts, expand_by: @deck_size, layout: @layout, dpi: @dpi)
      adjust= Args::EmbedAdjust.new.load!(opts, expand_by: @deck_size, layout: @layout, dpi: @dpi)
      trans = Args::Transform.new.load!(opts, expand_by: @deck_size, layout: @layout, dpi: @dpi)
      ifile = Args::InputFile.new.load!(opts, expand_by: @deck_size, layout: @layout, dpi: @dpi)
      rule  = { type: :png, file: ifile, box: box, paint: paint, trans: trans, adjust: adjust }
      rule[:draw] = Proc.new do |card, x, y|
        i = card.index
        b = box[i]
        b.x, b.y = x, y
        Dir.chdir(@img_dir) do
          card.png(ifile[i].file, b, paint[i], trans[i])
        end
      end
      @rules[key] = rule
    end

  end
end
