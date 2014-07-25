module Squib
  class Deck
    
    # Draw a rounded rectangle
    #
    # @param x: the x-coordinate to place
    # @param y: the y-coordinate to place
    # @param width: the width of the rectangle.
    # @param height: the height of the rectangle.
    # @param x_radius: the radius of the rounded corner horiztonally. Zero is a non-rounded corner.
    # @param y_radius: the radius of the rounded corner vertically. Zero is a non-rounded corner.
    # @param radius: when set, overrides both x_radius and y_radius
    # @param fill_color: the color with which to fill the rectangle
    # @param stroke_color: the color with which to stroke the outside of the rectangle
    # @param stroke_width: the width of the outside stroke
    # @api public
    def rect(opts = {})
      opts = needs(opts, [:range, :x, :y, :width, :height, :radius, 
                          :fill_color, :stroke_color, :stroke_width])
      opts[:range].each do |i|
        @cards[i].rect(opts[:x], opts[:y], opts[:width], opts[:height], 
          opts[:x_radius], opts[:y_radius], 
          opts[:fill_color], opts[:stroke_color], opts[:stroke_width])
      end
    end
    
  end
end