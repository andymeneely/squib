module Squib
  class Deck
    
    # Draw a rounded rectangle
    #
    # @param opts: the hash of options.
    # @option x: the x-coordinate to place
    # @option y: the y-coordinate to place
    # @option width: the width of the rectangle.
    # @option height: the height of the rectangle.
    # @option x_radius: the radius of the rounded corner horiztonally. Zero is a non-rounded corner.
    # @option y_radius: the radius of the rounded corner vertically. Zero is a non-rounded corner.
    # @option radius: when set, overrides both x_radius and y_radius
    # @option fill_color: the color with which to fill the rectangle
    # @option stroke_color: the color with which to stroke the outside of the rectangle
    # @option stroke_width: the width of the outside stroke
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