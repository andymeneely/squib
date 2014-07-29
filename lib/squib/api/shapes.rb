module Squib
  class Deck
    
    # Draw a rounded rectangle
    # 
    # @example 
    #   rect x: 0, y: 0, width: 825, height: 1125, radius: 25
    #
    # @option opts range [Enumerable, :all] (:all) the range of cards over which this will be rendered. See {file:API.md#label-Specifying+Ranges Specifying Ranges}
    # @option opts x [Integer] (0) the x-coordinate to place
    # @option opts y [Integer] (0) the y-coordinate to place
    # @option opts width [Integer] the width of the rectangle.
    # @option opts height [Integer] the height of the rectangle.
    # @option opts x_radius [Integer] (0) the radius of the rounded corner horiztonally. Zero is a non-rounded corner.
    # @option opts y_radius [Integer] (0) the radius of the rounded corner vertically. Zero is a non-rounded corner.
    # @option opts radius [Integer] (nil) when set, overrides both x_radius and y_radius
    # @option opts fill_color [String] ('#0000') the color with which to fill the rectangle
    # @option opts stroke_color [String] (:black) the color with which to stroke the outside of the rectangle
    # @option opts stroke_width [Decimal] (2.0) the width of the outside stroke
    # @option opts layout [String, Symbol] (nil) entry in the layout to use as defaults for this command. See {file:API.md#label-Custom+Layouts Custom Layouts}
    # @return [nil] intended to be void
    # @api public
    def rect(opts = {})
      opts = needs(opts, [:range, :x, :y, :width, :height, :radius, 
                          :fill_color, :stroke_color, :stroke_width, :layout])
      opts[:range].each do |i|
        @cards[i].rect(opts[:x], opts[:y], opts[:width], opts[:height], 
          opts[:x_radius], opts[:y_radius], 
          opts[:fill_color], opts[:stroke_color], opts[:stroke_width])
      end
    end

    # Draw a circle centered at the given coordinates
    # 
    # @example 
    #   circle x: 0, y: 0, radius: 100
    #
    # @option opts range [Enumerable, :all] (:all) the range of cards over which this will be rendered. See {file:API.md#label-Specifying+Ranges Specifying Ranges}
    # @option opts x [Integer] (0) the x-coordinate to place
    # @option opts y [Integer] (0) the y-coordinate to place
    # @option opts radius [Integer] (100) radius of the circle
    # @option opts fill_color [String] ('#0000') the color with which to fill the rectangle
    # @option opts stroke_color [String] (:black) the color with which to stroke the outside of the rectangle
    # @option opts stroke_width [Decimal] (2.0) the width of the outside stroke
    # @return [nil] intended to be void
    # @api public
    def circle(opts = {})
      opts = {radius: 100}.merge(opts)
      opts = needs(opts, [:range, :x, :y, :circle_radius, :layout,
                          :fill_color, :stroke_color, :stroke_width])
      opts[:range].each do |i|
        @cards[i].circle(opts[:x], opts[:y], opts[:radius], 
          opts[:fill_color], opts[:stroke_color], opts[:stroke_width])
      end
    end

    # Draw a triangle using the given coordinates
    # 
    # @example 
    #   triangle :x1 => 0, :y1 => 0, :x2 => 50, :y2 => 50, :x3 => 0, :y3 => 50
    #
    # @option opts range [Enumerable, :all] (:all) the range of cards over which this will be rendered. See {file:API.md#label-Specifying+Ranges Specifying Ranges}
    # @option opts x1 [Integer] (0) the x-coordinate to place
    # @option opts y1 [Integer] (0) the y-coordinate to place
    # @option opts x2 [Integer] (50) the x-coordinate to place
    # @option opts y2 [Integer] (50) the y-coordinate to place
    # @option opts x3 [Integer] (0) the x-coordinate to place
    # @option opts y3 [Integer] (50) the y-coordinate to place
    # @option opts fill_color [String] ('#0000') the color with which to fill the triangle
    # @option opts stroke_color [String] (:black) the color with which to stroke the outside of the triangle
    # @option opts stroke_width [Decimal] (2.0) the width of the outside stroke
    # @return [nil] intended to be void
    # @api public
    def triangle(opts = {})
      opts = needs(opts, [:range, :x1, :y1, :x2, :y2, :x3, :y3, :layout,
                          :fill_color, :stroke_color, :stroke_width])
      opts[:range].each do |i|
        @cards[i].triangle(opts[:x1], opts[:y1], opts[:x2], opts[:y2],opts[:x3], opts[:y3], 
          opts[:fill_color], opts[:stroke_color], opts[:stroke_width])
      end
    end

    # Draw a line using the given coordinates
    # 
    # @example 
    #   triangle :x1 => 0, :y1 => 0, :x2 => 50, :y2 => 50
    #
    # @option opts range [Enumerable, :all] (:all) the range of cards over which this will be rendered. See {file:API.md#label-Specifying+Ranges Specifying Ranges}
    # @option opts x1 [Integer] (0) the x-coordinate to place
    # @option opts y1 [Integer] (0) the y-coordinate to place
    # @option opts x2 [Integer] (50) the x-coordinate to place
    # @option opts y2 [Integer] (50) the y-coordinate to place
    # @option opts stroke_color [String] (:black) the color with which to stroke the line
    # @option opts stroke_width [Decimal] (2.0) the width of the outside stroke
    # @return [nil] intended to be void
    # @api public
    def line(opts = {})
      opts = needs(opts, [:range, :x1, :y1, :x2, :y2, :layout,
                          :stroke_color, :stroke_width])
      opts[:range].each do |i|
        @cards[i].line(opts[:x1], opts[:y1], opts[:x2], opts[:y2],
                       opts[:stroke_color], opts[:stroke_width])
      end
    end
    
  end
end