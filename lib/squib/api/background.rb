module Squib
  class Deck
    #module API

      def background(range: :all, color: :black)
        range = rangeify(range)
        color = colorify(color)
        range.each { |i| @cards[i].background(color) }
      end
      
    #end
  end
end