module Squib
  class Card
      
    def draw_rectangle(x, y, width, height, x_radius, y_radius, color)
      cc = cairo_context
      cc.set_source_color(color)
      cc.rounded_rectangle(x, y, width, height, x_radius, y_radius)
      cc.stroke
    end
      
  end
end