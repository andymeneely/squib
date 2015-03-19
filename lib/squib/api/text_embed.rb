module Squib
  class TextEmbed
    # :nodoc:
    # @api private
    attr_reader :rules

    # :nodoc:
    # @api private
    def initialize
      @rules = {} # store an array of options for later usage
    end

    # Context object for embedding an svg icon within text
    #
    # @option opts key [String] ('*') the string to replace with the graphic. Can be multiple letters, e.g. ':tool:'
    # @option opts file [String] ('') file(s) to read in. If it's a single file, then it's use for every card in range. If the parameter is an Array of files, then each file is looked up for each card. If any of them are nil or '', nothing is done. See {file:README.md#Specifying_Files Specifying Files}. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    # @option opts id [String] (nil) if set, then only render the SVG element with the given id. Prefix '#' is optional. Note: the x-y coordinates are still relative to the SVG document's page. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    # @option opts force_id [Boolean] (false) if set, then this svg will not be rendered at all if the id is empty or nil. If not set, the entire SVG is rendered. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    # @option opts layout [String, Symbol] (nil) entry in the layout to use as defaults for this command. See {file:README.md#Custom_Layouts Custom Layouts}. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    # @option opts width [Integer, :native] (:native) the width of the image rendered
    # @option opts height [Integer, :native] the height the height of the image rendered
    # @option opts alpha [Decimal] (1.0) the alpha-transparency percentage used to blend this image. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    # @option opts blend [:none, :multiply, :screen, :overlay, :darken, :lighten, :color_dodge, :color_burn, :hard_light, :soft_light, :difference, :exclusion, :hsl_hue, :hsl_saturation, :hsl_color, :hsl_luminosity] (:none) the composite blend operator used when applying this image. See Blend Modes at http://cairographics.org/operators. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    # @option opts angle [FixNum] (0) Rotation of the in radians. Note that this rotates around the upper-left corner, making the placement of x-y coordinates slightly tricky. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    # @api public
    def svg(opts)
      opts = Squib::SYSTEM_DEFAULTS.merge(opts)
      # TODO: add input validation here. We need the key for example.
      rule = {type: :svg}.merge(opts)
      rule[:draw] = Proc.new do |card, x,y|
        card.svg(rule[:file], rule[:id], x, y, rule[:width], rule[:height],
                 rule[:alpha], rule[:blend], rule[:angle], rule[:mask])
      end
      @rules[opts[:key]] = rule
    end

    # Context object for embedding a png within text
    #
    # @option opts key [String] ('*') the string to replace with the graphic. Can be multiple letters, e.g. ':tool:'
    # @option opts file [String] ('') file(s) to read in. If it's a single file, then it's use for every card in range. If the parameter is an Array of files, then each file is looked up for each card. If any of them are nil or '', nothing is done. See {file:README.md#Specifying_Files Specifying Files}. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    # @option opts layout [String, Symbol] (nil) entry in the layout to use as defaults for this command. See {file:README.md#Custom_Layouts Custom Layouts}. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    # @option opts width [Integer, :native] (:native) the width of the image rendered
    # @option opts height [Integer, :native] the height the height of the image rendered
    # @option opts alpha [Decimal] (1.0) the alpha-transparency percentage used to blend this image. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    # @option opts blend [:none, :multiply, :screen, :overlay, :darken, :lighten, :color_dodge, :color_burn, :hard_light, :soft_light, :difference, :exclusion, :hsl_hue, :hsl_saturation, :hsl_color, :hsl_luminosity] (:none) the composite blend operator used when applying this image. See Blend Modes at http://cairographics.org/operators. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    # @option opts angle [FixNum] (0) Rotation of the in radians. Note that this rotates around the upper-left corner, making the placement of x-y coordinates slightly tricky. Supports Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    # @api public
    def png(opts)
      opts = Squib::SYSTEM_DEFAULTS.merge(opts)
      # TODO: add input validation here. We need the key for example.
      rule = {type: :png}.merge(opts)
      rule[:draw] = Proc.new do |card, x,y|
        card.png(rule[:file], x, y, rule[:width], rule[:height],
                 rule[:alpha], rule[:blend], rule[:angle], rule[:mask])
      end
      @rules[opts[:key]] = rule
    end

  end
end