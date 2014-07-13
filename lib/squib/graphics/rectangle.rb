module Squib
  module Graphics

    class Rectangle
      
      def initialize(card, x, y, width, height, x_radius, y_radius)
        @card=card; @x=x; @y=y; @width=width; @height=height
        @x_radius=x_radius; @y_radius=y_radius
      end

      def execute
        cc = @card.cairo_context
        cc.set_source_rgb(0.0,0.0,0.0)
        cc.rounded_rectangle(@x, @y, @width, @height, @x_radius, @y_radius)
        cc.stroke
      end

    end

  end
end