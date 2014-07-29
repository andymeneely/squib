require 'yaml'
require 'pp'
require 'squib/card'
require 'squib/input_helpers'
require 'squib/constants'

# The project module
#
# @api public
module Squib

  # The main interface to Squib. Provides a front-end porcelain whereas the Card class interacts with the graphics plumbing.
  #
  # @api public
  class Deck
    include Enumerable
    include Squib::InputHelpers

    # :nodoc:
    # @api private 
    attr_reader :width, :height
    
    # :nodoc:
    # @api private 
    attr_reader :cards
    
    # :nodoc:
    # @api private 
    attr_reader :text_hint

    # Squib's constructor that sets the immutable properties.
    #
    # This is the starting point for Squib. In providing a block to the constructor, you have access to all of Deck's instance methods. 
    # The documented methods in Deck are the ones intended for use by most users. 
    # If your game requires multiple different sizes or orientations, I recommend using multiple `Squib::Deck`s in your `deck.rb`. You can modify the internals of `Squib::Deck` (e.g. `@cards`), but that's not recommended.
    # @example 
    #   require 'squib'
    #   Squib::Deck.new do
    #     text str: 'Hello, World!'
    #   end
    # 
    # @param width: [Integer] the width of each card in pixels
    # @param height: [Integer] the height of each card in pixels
    # @param cards: [Integer] the number of cards in the deck
    # @param dpi: [Integer] the pixels per inch when rendering out to PDF or calculating using inches. 
    # @param config: [String] the file used for global settings of this deck
    # @param block [Block] the main body of the script.
    # @api public
    def initialize(width: 825, height: 1125, cards: 1, dpi: 300, config: 'config.yml', layout: nil, &block)
      @width=width; @height=height
      @dpi = dpi
      @font = Squib::SYSTEM_DEFAULTS[:default_font]
      @cards = []
      cards.times{ @cards << Squib::Card.new(self, width, height) }
      load_config(config)
      load_layout(layout)
      if block_given?
        instance_eval(&block)
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

    # Load the configuration file, if exists, overriding hardcoded defaults
    # @api private
    def load_config(file)
      if File.exists? file
        if config = YAML.load_file(file)
          @dpi = config['dpi'].to_i
        end
      end
    end

    # Load the layout configuration file, if exists
    # @api private
    def load_layout(file)
      return if file.nil?
      prelayout = YAML.load_file(file)
      @layout = {}
      prelayout.each do |key, value|
        if value.key? "extends"
          @layout[key] = prelayout[value["extends"]].merge prelayout[key]
        else 
          @layout[key] = value
        end
      end
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