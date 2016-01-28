require 'forwardable'
require 'pp'
require 'squib'
require 'squib/args/unit_conversion'
require 'squib/args/vendor_args'
require 'squib/args/bleed'
require 'squib/card'
require 'squib/conf'
require 'squib/constants'
require 'squib/graphics/hand'
require 'squib/graphics/showcase'
require 'squib/layout_parser'
require 'squib/progress'


# The project module
#
# @api public
module Squib

  # The main interface to Squib. Provides a front-end porcelain whereas the Card class interacts with the graphics plumbing.
  #
  # @api public
  class Deck
    include Enumerable
    extend Forwardable

    # Attributes for the width, height (in pixels) and number of cards
    # These are expected to be immuatble for the life of Deck
    # @api private
    attr_reader :width, :height, :cards

    # Delegate these configuration options to the Squib::Conf object
    def_delegators :conf, :antialias, :backend, :count_format, :custom_colors, :dir,
                          :img_dir, :prefix, :text_hint, :typographer
    # :nodoc:
    # @api private
    attr_reader :layout, :conf, :dpi, :font

    #
    # deck.size is really just @cards.size
    def_delegators :cards, :size

    # Squib's constructor that sets the immutable properties.
    #
    # This is the starting point for Squib. In providing a block to the constructor, you have access to all of Deck's instance methods.
    # The documented methods in Deck are the ones intended for use by most users.
    # If your game requires multiple different sizes or orientations, I recommend using multiple `Squib::Deck`s in your `deck.rb`. You can modify the internals of `Squib::Deck` (e.g. `@cards`), but that's not recommended.
    # @example
    #   require 'squib'
    #   Squib::Deck.new do
    #     text str: 'Hello, World!"
    #   end
    #
    # @param width [Integer] the width of each card in pixels. Supports unit conversion (e.g. '2.5in').
    # @param height [Integer] the height of each card in pixels. Supports unit conversion (e.g. '3.5in').
    # c
    # @param dpi [Integer] the pixels per inch when rendering out to PDF or calculating using inches.
    # @param config [String] the file used for global settings of this deck
    # @param layout [String, Array] load a YML file of custom layouts. Multiple files are merged sequentially, redefining collisons. See README and sample for details.
    # @param block [Block] the main body of the script.
    # @api public
    def initialize(width: 825, height: 1125, cards: 1, dpi: 300, config: 'config.yml', layout: nil, **factory_args, &block)
      @dpi           = dpi
      @font          = DEFAULT_FONT
      @cards         = []
      @conf          = Conf.load(config)
      @progress_bar  = Progress.new(@conf.progress_bars) # FIXME this is evil. Using something different with @ and non-@
      show_info(config, layout)
      @width         = Args::UnitConversion.parse width, dpi
      @height        = Args::UnitConversion.parse height, dpi
      cards.times{ |i| @cards << Squib::Card.new(self, @width, @height, i) }
      @layout        = LayoutParser.load_layout(layout)
      @card_name = factory_args[:card_name]
      @vendor = factory_args[:vendor]
      if block_given?
        instance_eval(&block) # here we go. wheeeee!
      end
    end

    # Squib also provides a convienence method that make accessing common card sizes easy.  For example, Squib::Deck.new_from_preset(card_name: "poker") will call Squib::Deck.new, with height: '3.5in' and width: '2.5in' and passing through other parameters.
    # @example
      #   require 'squib'
      #   Squib::Deck.new_from_preset card_name: poker
    # This will create a new deck with a height of 3.5in and a width of 2.5in.
    # This method can accept the same additional paramaters as Squib::Deck.new--dpi, layout, config, and cards
    #
    # Using this method also allows you to easily work with print-and-play vendors.  When you pass a vendor argument, new_from_preset will set the dpi and increase the height and width of the deck to factor in the bleed the vendor uses.
    # @param card_name [symbol or string] the name of the preset card size.
    # Currently supported preset card sizes: poker, bridge, large, hobbit, square, and business.
    # @param vendor [symbol or string] the name of the vendor you wish to use.
      # Currently supported vendors: pnp_productions.  More coming soon!
    # @api public
    def self.new_from_preset(**args, &block)
      dpi = args[:dpi] ||= 300
      card = args[:card_name].to_s
      args.merge! Squib::Args::VendorArgs.base_options(card)

      vendor = args[:vendor]
      if vendor
        vendor_opts = Squib::Args::VendorArgs.vendor_options(card, vendor.to_s)
        args.merge! vendor_opts if vendor_opts
      end

      unless args[:bleed].nil?
        args[:height] = Args::Bleed.add args[:height], args[:bleed], dpi
        args[:width] = Args::Bleed.add args[:width], args[:bleed], dpi
      end

      sym_args = {}
      args.each_pair do |key, val|
        sym_args[key.to_sym] = val
      end

      Squib::Deck.new **sym_args, &block

    end

    # Directly accesses the array of cards in the deck
    #
    # @api private
    def [](key)
      @cards[key]
    end

    # Iterates over each card in the deck
    #
    # @api private
    def each(&block)
      @cards.each { |card| block.call(card) }
    end

    # Use Logger to show more detail on the run
    # :nodoc:
    # @api private
    def show_info(config, layout)
      Squib::logger.info "Squib v#{Squib::VERSION}"
      Squib::logger.info "  building #{@cards.size} #{@width}x#{@height} cards"
      Squib::logger.info "  using #{@backend}"
    end

    ##################
    ### PUBLIC API ###
    ##################
    require 'squib/api/background'
    require 'squib/api/data'
    require 'squib/api/image'
    require 'squib/api/save'
    require 'squib/api/settings'
    require 'squib/api/shapes'
    require 'squib/api/text'
    require 'squib/api/units'

  end
end
