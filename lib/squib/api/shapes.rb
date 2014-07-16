module Squib
  class Deck
    
    def rect(range: :all, x: 0, y: 0, width: 825, height: 1125, \
              x_radius: 0, y_radius: 0)
      range = rangeify(range)
      range.each do |i|
        @cards[i].draw_rectangle(x, y, width, height, x_radius, y_radius)
      end
    end
    
  end
end