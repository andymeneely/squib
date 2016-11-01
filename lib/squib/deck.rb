require 'forwardable'
require 'pp'
require_relative '../squib'
require_relative 'args/unit_conversion'
require_relative 'card'
require_relative 'conf'
require_relative 'constants'
require_relative 'graphics/hand'
require_relative 'graphics/showcase'
require_relative 'layout_parser'
require_relative 'progress'


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
    attr_reader :width, :height, :cards, :progress_bar

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
    # @param cards [Integer] the number of cards in the deck
    # @param dpi [Integer] the pixels per inch when rendering out to PDF or calculating using inches.
    # @param config [String] the file used for global settings of this deck
    # @param layout [String, Array] load a YML file of custom layouts. Multiple files are merged sequentially, redefining collisons. See README and sample for details.
    # @param block [Block] the main body of the script.
    # @api public
    def initialize(width: 825, height: 1125, cards: 1, dpi: 300, config: 'config.yml', layout: nil, &block)
      @dpi           = dpi
      @font          = DEFAULT_FONT
      @cards         = []
      @conf          = Conf.load(config)
      @progress_bar  = Progress.new(@conf.progress_bars) # FIXME this is evil. Using something different with @ and non-@
      show_info(config, layout)
      @width         = Args::UnitConversion.parse width, dpi
      @height        = Args::UnitConversion.parse height, dpi
      cards.times{ |i| @cards << Squib::Card.new(self, @width, @height, i) }
      @layout = LayoutParser.new(dpi).load_layout(layout)
      enable_groups_from_env!
      if block_given?
        instance_eval(&block) # here we go. wheeeee!
      end
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
    require_relative 'api/background'
    require_relative 'api/data'
    require_relative 'api/groups'
    require_relative 'api/image'
    require_relative 'api/save'
    require_relative 'api/settings'
    require_relative 'api/shapes'
    require_relative 'api/text'
    require_relative 'api/units'

  end
end
