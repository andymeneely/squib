require 'yaml'
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
    attr_reader :width, :height
    attr_reader :cards
    attr_reader :text_hint

    # Squib's constructor that sets the immutable properties.
    # 
    # @api public
    def initialize(width: 825, height: 1125, cards: 1, dpi: 300, config: 'config.yml', &block)
      @width=width; @height=height
      @dpi = dpi
      @font = Squib::SYSTEM_DEFAULTS[:font]
      @cards = []
      cards.times{ @cards << Squib::Card.new(self, width, height) }
      load_config(config)
      if block_given?
        instance_eval(&block)
      end
    end

    # Directly accesses the array of cards in the deck
    #
    # @api public
    def [](key)
      @cards[key]
    end

    # Iterates over each card in the deck
    # 
    # @api public
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