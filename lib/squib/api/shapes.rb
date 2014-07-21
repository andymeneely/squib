module Squib
  class Deck
    
    def rect(range: :all, x: 0, y: 0, width: 825, height: 1125, \
              radius: 0, x_radius: 0, y_radius: 0, color: :black)
      range = rangeify(range)
      color = colorify(color)
      x_radius,y_radius = radiusify(radius, x_radius, y_radius)
      range.each do |i|
        @cards[i].draw_rectangle(x, y, width, height, x_radius, y_radius, color)
      end
    end
    
  end
end