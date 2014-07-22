module Squib
  class Deck
    
    def rect(range: :all, x: 0, y: 0, width: 825, height: 1125, \
              radius: nil, x_radius: 0, y_radius: 0, \
              fill_color: '#0000', stroke_color: :black, stroke_width: 2.0)
      range = rangeify(range)
      color = colorify(color)
      x_radius,y_radius = radiusify(radius, x_radius, y_radius)
      range.each do |i|
        @cards[i].draw_rectangle(x, y, width, height, x_radius, y_radius, fill_color, stroke_color, stroke_width)
      end
    end
    
  end
end