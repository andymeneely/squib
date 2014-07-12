require 'squib/card'
module Squib

  class Deck
    include Enumerable
    attr_reader :width, :height, :num_cards

    def initialize(width, height, cards)
      @width=width; @height=height; @num_cards=cards
      @cards = []
      num_cards.times{ @cards << Squib::Card.new(width, height) }
    end

    def [](key)
      @cards[key]
    end

    #For enumerables
    def each(&block)
      @cards.each { |card| block.call(card) }
    end

  end
end