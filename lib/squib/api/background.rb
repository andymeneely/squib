module Squib
  class Deck
    #module API

      def background(range: :all, color: '#000000')
        range = rangeify(range)
        range.each { |i| @cards[i].background(color) }
      end
      
    #end
  end
end