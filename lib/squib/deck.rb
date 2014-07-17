require 'squib/card'

module Squib
  class Deck
    include Enumerable
    attr_reader :width, :height
    attr_reader :cards

    def initialize(width: 825, height: 1125, cards: 1, &block)
      @width=width; @height=height
      @cards = []
      cards.times{ @cards << Squib::Card.new(width, height) }
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

    def rangeify (range)
      range = 0..(@cards.size-1) if range == :all
      range = range..range if range.is_a? Integer
      return range
    end

    def fileify(file)
      raise 'File #{file} does not exist!' unless File.exists? file
      file
    end

    ##################
    ### PUBLIC API ###
    ##################
    require 'squib/api/background'
    require 'squib/api/data'
    require 'squib/api/image'
    require 'squib/api/save'
    require 'squib/api/shapes'
    require 'squib/api/text'

  end
end