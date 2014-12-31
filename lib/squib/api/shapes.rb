module Squib
  class Deck

    # Draw a rounded rectangle
    #
    # @example
    #   rect x: 0, y: 0, width: 825, height: 1125, radius: 25
    #
    # Options support Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    #
    # @option opts range [Enumerable, :all] (:all) the range of cards over which this will be rendered. See {file:README.md#Specifying_Ranges Specifying Ranges}
    # @option opts x [Integer] (0) the x-coordinate to place. Supports Unit Conversion, see {file:README#Units Units}.
    # @option opts y [Integer] (0) the y-coordinate to place. Supports Unit Conversion, see {file:README#Units Units}.
    # @option opts width [Integer] the width of the rectangle. Supports Unit Conversion, see {file:README#Units Units}.
    # @option opts height [Integer] the height of the rectangle. Supports Unit Conversion, see {file:README#Units Units}.
    # @option opts x_radius [Integer] (0) the radius of the rounded corner horiztonally. Zero is a non-rounded corner. Supports Unit Conversion, see {file:README#Units Units}.
    # @option opts y_radius [Integer] (0) the radius of the rounded corner vertically. Zero is a non-rounded corner. Supports Unit Conversion, see {file:README#Units Units}.
    # @option opts radius [Integer] (nil) when set, overrides both x_radius and y_radius. Supports Unit Conversion, see {file:README#Units Units}.
    # @option opts fill_color [String] ('#0000') the color with which to fill the rectangle
    # @option opts stroke_color [String] (:black) the color with which to stroke the outside of the rectangle
    # @option opts stroke_width [Decimal] (2.0) the width of the outside stroke. Supports Unit Conversion, see {file:README#Units Units}.
    # @option opts layout [String, Symbol] (nil) entry in the layout to use as defaults for this command. See {file:README.md#Custom_Layouts Custom Layouts}
    # @return [nil] intended to be void
    # @api public
    def rect(opts = {})
      opts = needs(opts, [:range, :x, :y, :width, :height, :rect_radius, :x_radius, :y_radius,
                          :fill_color, :stroke_color, :stroke_width, :layout])
      opts[:range].each do |i|
        @cards[i].rect(opts[:x][i], opts[:y][i], opts[:width][i], opts[:height][i],
                       opts[:x_radius][i], opts[:y_radius][i],
                       opts[:fill_color][i], opts[:stroke_color][i],
                       opts[:stroke_width][i])
      end
    end

    # Draw a circle centered at the given coordinates
    #
    # @example
    #   circle x: 0, y: 0, radius: 100
    #
    # Options support Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    #
    # @option opts range [Enumerable, :all] (:all) the range of cards over which this will be rendered. See {file:README.md#Specifying_Ranges Specifying Ranges}
    # @option opts x [Integer] (0) the x-coordinate to place. Supports Unit Conversion, see {file:README#Units Units}.
    # @option opts y [Integer] (0) the y-coordinate to place. Supports Unit Conversion, see {file:README#Units Units}.
    # @option opts radius [Integer] (100) radius of the circle. Supports Unit Conversion, see {file:README#Units Units}.
    # @option opts fill_color [String] ('#0000') the color with which to fill the rectangle
    # @option opts stroke_color [String] (:black) the color with which to stroke the outside of the rectangle
    # @option opts stroke_width [Decimal] (2.0) the width of the outside stroke. Supports Unit Conversion, see {file:README#Units Units}.
    # @return [nil] intended to be void
    # @api public
    def circle(opts = {})
      opts = {radius: 100}.merge(opts) # overriding the non-system default
      opts = needs(opts, [:range, :x, :y, :circle_radius, :layout,
                          :fill_color, :stroke_color, :stroke_width])
      opts[:range].each do |i|
        @cards[i].circle(opts[:x][i], opts[:y][i], opts[:radius][i],
          opts[:fill_color][i], opts[:stroke_color][i], opts[:stroke_width][i])
      end
    end

    # Draw a triangle using the given coordinates
    #
    # @example
    #   triangle :x1 => 0, :y1 => 0, :x2 => 50, :y2 => 50, :x3 => 0, :y3 => 50
    #
    # Options support Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    #
    # @option opts range [Enumerable, :all] (:all) the range of cards over which this will be rendered. See {file:README.md#Specifying_Ranges Specifying Ranges}
    # @option opts x1 [Integer] (0) the x-coordinate to place. Supports Unit Conversion, see {file:README#Units Units}.
    # @option opts y1 [Integer] (0) the y-coordinate to place. Supports Unit Conversion, see {file:README#Units Units}.
    # @option opts x2 [Integer] (50) the x-coordinate to place. Supports Unit Conversion, see {file:README#Units Units}.
    # @option opts y2 [Integer] (50) the y-coordinate to place. Supports Unit Conversion, see {file:README#Units Units}.
    # @option opts x3 [Integer] (0) the x-coordinate to place. Supports Unit Conversion, see {file:README#Units Units}.
    # @option opts y3 [Integer] (50) the y-coordinate to place. Supports Unit Conversion, see {file:README#Units Units}.
    # @option opts fill_color [String] ('#0000') the color with which to fill the triangle
    # @option opts stroke_color [String] (:black) the color with which to stroke the outside of the triangle
    # @option opts stroke_width [Decimal] (2.0) the width of the outside stroke. Supports Unit Conversion, see {file:README#Units Units}.
    # @return [nil] intended to be void
    # @api public
    def triangle(opts = {})
      opts = needs(opts, [:range, :x1, :y1, :x2, :y2, :x3, :y3, :layout,
                          :fill_color, :stroke_color, :stroke_width])
      opts[:range].each do |i|
        @cards[i].triangle(opts[:x1][i], opts[:y1][i],
                           opts[:x2][i], opts[:y2][i],
                           opts[:x3][i], opts[:y3][i],
                           opts[:fill_color][i], opts[:stroke_color][i],
                           opts[:stroke_width][i])
      end
    end

    # Draw a line using the given coordinates
    #
    # @example
    #   triangle :x1 => 0, :y1 => 0, :x2 => 50, :y2 => 50
    #
    # @option opts range [Enumerable, :all] (:all) the range of cards over which this will be rendered. See {file:README.md#Specifying_Ranges Specifying Ranges}
    # @option opts x1 [Integer] (0) the x-coordinate to place. Supports Unit Conversion, see {file:README#Units Units}.
    # @option opts y1 [Integer] (0) the y-coordinate to place. Supports Unit Conversion, see {file:README#Units Units}.
    # @option opts x2 [Integer] (50) the x-coordinate to place. Supports Unit Conversion, see {file:README#Units Units}.
    # @option opts y2 [Integer] (50) the y-coordinate to place. Supports Unit Conversion, see {file:README#Units Units}.
    # @option opts stroke_color [String] (:black) the color with which to stroke the line
    # @option opts stroke_width [Decimal] (2.0) the width of the outside stroke. Supports Unit Conversion, see {file:README#Units Units}.
    # @return [nil] intended to be void
    # @api public
    def line(opts = {})
      opts = needs(opts, [:range, :x1, :y1, :x2, :y2, :layout,
                          :stroke_color, :stroke_width])
      opts[:range].each do |i|
        @cards[i].line(opts[:x1][i], opts[:y1][i], opts[:x2][i], opts[:y2][i],
                       opts[:stroke_color][i], opts[:stroke_width][i])
      end
    end

  end
end
