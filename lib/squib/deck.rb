require 'squib/card'
require 'squib/input_helpers'

module Squib
  class Deck
    include Enumerable
    include Squib::InputHelpers
    attr_reader :width, :height
    attr_reader :cards
    attr_reader :text_hint

    def initialize(width: 825, height: 1125, cards: 1, &block)
      @width=width; @height=height
      @cards = []
      cards.times{ @cards << Squib::Card.new(self, width, height) }
      if block_given?
        instance_eval(&block)
      end
    end

    def [](key)
      @cards[key]
    end

    #For Enumerable
    def each(&block)
      @cards.each { |card| block.call(card) }
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