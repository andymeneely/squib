require 'yaml'
require 'squib/card'
require 'squib/input_helpers'
require 'squib/constants'

module Squib
  class Deck
    include Enumerable
    include Squib::InputHelpers
    include Squib::Constants
    attr_reader :width, :height
    attr_reader :cards
    attr_reader :text_hint

    def initialize(width: 825, height: 1125, cards: 1, config: 'config.yml', &block)
      @width=width; @height=height
      @dpi = 300
      @font = 'Sans 36'
      @cards = []
      cards.times{ @cards << Squib::Card.new(self, width, height) }
      load_config(config)
      if block_given?
        instance_eval(&block)
      end
    end

    # API: Accesses the array of cards in the deck
    # @api public
    def [](key)
      @cards[key]
    end

    # Public: Accesses each card of the array in the deck
    # @api 
    def each(&block)
      @cards.each { |card| block.call(card) }
    end

    # Internal: Load the configuration file, if exists, 
    # overriding hardcoded defaults
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

  end
end