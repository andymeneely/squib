require 'squib/card'
module Squib

  class Deck
    attr_reader :width, :height, :cards

    def initialize(width: 825, height: 1125, cards: 1)
      @width=width; @height=height; @cards=cards
      @deck = Array.new(cards)
      (1..cards).each{ @deck << Squib::Card.new(width: width, height: height) }
    end




  end

end