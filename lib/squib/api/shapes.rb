require 'squib/args/box'
require 'squib/args/draw'
require 'squib/args/card_range'
require 'squib/args/transform'
require 'squib/args/coords'

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
    # @option opts x [Integer] (0) the x-coordinate to place. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts y [Integer] (0) the y-coordinate to place. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts width [Integer] the width of the rectangle. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts height [Integer] the height of the rectangle. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts x_radius [Integer] (0) the radius of the rounded corner horiztonally. Zero is a non-rounded corner. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts y_radius [Integer] (0) the radius of the rounded corner vertically. Zero is a non-rounded corner. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts radius [Integer] (nil) when set, overrides both x_radius and y_radius. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts fill_color [String] ('#0000') the color with which to fill the rectangle. See {file:README.md#Specifying_Colors___Gradients Specifying Colors & Gradients}
    # @option opts stroke_color [String] (:black) the color with which to stroke the outside of the rectangle. {file:README.md#Specifying_Colors___Gradients Specifying Colors & Gradients}
    # @option opts stroke_width [Decimal] (2.0) the width of the outside stroke. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts stroke_strategy [:fill_first, :stroke_first] (:fill_first) specify whether the stroke is done before (thinner) or after (thicker) filling the shape.
    # @option opts join [String] ('miter') how corners will be drawn on stroke. Options are 'miter', 'bevel', or 'round'. Note that this is separate from the x_radius and y_radius of the rounded rectangle. Becomes more obvious with wider strokes.
    # @option opts dash [String] ('') define a dash pattern for the stroke. Provide a string with space-separated numbers that define the pattern of on-and-off alternating strokes, measured in pixels by defautl. Supports Unit Conversion, see {file:README.md#Units Units} (e.g. `'0.02in 0.02in'`).
    # @option opts layout [String, Symbol] (nil) entry in the layout to use as defaults for this command. See {file:README.md#Custom_Layouts Custom Layouts}
    # @return [nil] intended to be void
    # @api public
    def rect(opts = {})
      range = Args::CardRange.new(opts[:range], deck_size: size)
      box   = Args::Box.new(self).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      draw  = Args::Draw.new(custom_colors).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      range.each { |i| @cards[i].rect(box[i], draw[i]) }
    end

    # Draw a circle centered at the given coordinates
    #
    # @example
    #   circle x: 0, y: 0, radius: 100
    #
    # Options support Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    #
    # @option opts range [Enumerable, :all] (:all) the range of cards over which this will be rendered. See {file:README.md#Specifying_Ranges Specifying Ranges}
    # @option opts x [Integer] (0) the x-coordinate to place. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts y [Integer] (0) the y-coordinate to place. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts radius [Integer] (100) radius of the circle. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts fill_color [String] ('#0000') the color with which to fill the rectangle. See {file:README.md#Specifying_Colors___Gradients Specifying Colors & Gradients}.
    # @option opts stroke_color [String] (:black) the color with which to stroke the outside of the rectangle. See {file:README.md#Specifying_Colors___Gradients Specifying Colors & Gradients}.
    # @option opts stroke_width [Decimal] (2.0) the width of the outside stroke. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts stroke_strategy [:fill_first, :stroke_first] (:fill_first) specify whether the stroke is done before (thinner) or after (thicker) filling the shape.
    # @option opts dash [String] ('') define a dash pattern for the stroke. Provide a string with space-separated numbers that define the pattern of on-and-off alternating strokes, measured in pixels by defautl. Supports Unit Conversion, see {file:README.md#Units Units} (e.g. `'0.02in 0.02in'`).
    # @option opts layout [String, Symbol] (nil) entry in the layout to use as defaults for this command. See {file:README.md#Custom_Layouts Custom Layouts}
    # @return [nil] intended to be void
    # @api public
    def circle(opts = {})
      range  = Args::CardRange.new(opts[:range], deck_size: size)
      coords = Args::Coords.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
      draw   = Args::Draw.new(custom_colors).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      range.each { |i| @cards[i].circle(coords[i], draw[i]) }
    end

    # Draw an ellipse
    #
    # @example
    #   ellipse x: 0, y: 0, width: 825, height: 1125
    #
    # Options support Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    #
    # @option opts range [Enumerable, :all] (:all) the range of cards over which this will be rendered. See {file:README.md#Specifying_Ranges Specifying Ranges}
    # @option opts x [Integer] (0) the x-coordinate to place. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts y [Integer] (0) the y-coordinate to place. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts width [Integer] (0.25in) the width of the rectangle. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts height [Integer] (0.25in) the height of the rectangle. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts fill_color [String] ('#0000') the color with which to fill the rectangle. See {file:README.md#Specifying_Colors___Gradients Specifying Colors & Gradients}
    # @option opts stroke_color [String] (:black) the color with which to stroke the outside of the rectangle. {file:README.md#Specifying_Colors___Gradients Specifying Colors & Gradients}
    # @option opts stroke_width [Decimal] (2.0) the width of the outside stroke. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts stroke_strategy [:fill_first, :stroke_first] (:fill_first) specify whether the stroke is done before (thinner) or after (thicker) filling the shape.
    # @option opts dash [String] ('') define a dash pattern for the stroke. Provide a string with space-separated numbers that define the pattern of on-and-off alternating strokes, measured in pixels by defautl. Supports Unit Conversion, see {file:README.md#Units Units} (e.g. `'0.02in 0.02in'`).
    # @option opts layout [String, Symbol] (nil) entry in the layout to use as defaults for this command. See {file:README.md#Custom_Layouts Custom Layouts}
    # @return [nil] intended to be void
    # @api public
    def ellipse(opts = {})
      range = Args::CardRange.new(opts[:range], deck_size: size)
      draw  = Args::Draw.new(custom_colors).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      box   = Args::Box.new(self, {width: '0.25in', height: '0.25in'}).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      range.each { |i| @cards[i].ellipse(box[i], draw[i]) }
    end

    # Draw an unlimited grid
    #
    # @example
    #   grid x: 0, y: 0, width: 15, height: 15
    #
    # Options support Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    #
    # @option opts range [Enumerable, :all] (:all) the range of cards over which this will be rendered. See {file:README.md#Specifying_Ranges Specifying Ranges}
    # @option opts x [Integer] (0) the x-coordinate to place. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts y [Integer] (0) the y-coordinate to place. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts width [Integer] the width of the rectangle. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts height [Integer] the height of the rectangle. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts stroke_color [String] (:black) the color with which to stroke the outside of the rectangle. {file:README.md#Specifying_Colors___Gradients Specifying Colors & Gradients}
    # @option opts stroke_width [Decimal] (2.0) the width of the outside stroke. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts dash [String] ('') define a dash pattern for the stroke. Provide a string with space-separated numbers that define the pattern of on-and-off alternating strokes, measured in pixels by defautl. Supports Unit Conversion, see {file:README.md#Units Units} (e.g. `'0.02in 0.02in'`).
    # @option opts layout [String, Symbol] (nil) entry in the layout to use as defaults for this command. See {file:README.md#Custom_Layouts Custom Layouts}
    # @return [nil] intended to be void
    # @api public
    def grid(opts = {})
      range = Args::CardRange.new(opts[:range], deck_size: size)
      draw  = Args::Draw.new(custom_colors).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      box   = Args::Box.new(self).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      range.each { |i| @cards[i].grid(box[i], draw[i]) }
    end

    # Draw a triangle using the given coordinates
    #
    # @example
    #   triangle :x1 => 0, :y1 => 0, :x2 => 50, :y2 => 50, :x3 => 0, :y3 => 50
    #
    # Options support Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    #
    # @option opts range [Enumerable, :all] (:all) the range of cards over which this will be rendered. See {file:README.md#Specifying_Ranges Specifying Ranges}
    # @option opts x1 [Integer] (0) the x-coordinate to place. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts y1 [Integer] (0) the y-coordinate to place. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts x2 [Integer] (50) the x-coordinate to place. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts y2 [Integer] (50) the y-coordinate to place. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts x3 [Integer] (0) the x-coordinate to place. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts y3 [Integer] (50) the y-coordinate to place. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts fill_color [String] ('#0000') the color with which to fill the triangle. See {file:README.md#Specifying_Colors___Gradients Specifying Colors & Gradients}
    # @option opts stroke_color [String] (:black) the color with which to stroke the outside of the triangle. See {file:README.md#Specifying_Colors___Gradients Specifying Colors & Gradients}
    # @option opts stroke_width [Decimal] (2.0) the width of the outside stroke. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts stroke_strategy [:fill_first, :stroke_first] (:fill_first) specify whether the stroke is done before (thinner) or after (thicker) filling the shape.
    # @option opts dash [String] ('') define a dash pattern for the stroke. Provide a string with space-separated numbers that define the pattern of on-and-off alternating strokes, measured in pixels by defautl. Supports Unit Conversion, see {file:README.md#Units Units} (e.g. `'0.02in 0.02in'`).
    # @option opts layout [String, Symbol] (nil) entry in the layout to use as defaults for this command. See {file:README.md#Custom_Layouts Custom Layouts}
    # @return [nil] intended to be void
    # @api public
    def triangle(opts = {})
      range  = Args::CardRange.new(opts[:range], deck_size: size)
      draw   = Args::Draw.new(custom_colors).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      coords = Args::Coords.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
      range.each { |i| @cards[i].triangle(coords[i], draw[i]) }
    end

    # Draw a line using the given coordinates
    #
    # @example
    #   triangle :x1 => 0, :y1 => 0, :x2 => 50, :y2 => 50
    #
    # @option opts range [Enumerable, :all] (:all) the range of cards over which this will be rendered. See {file:README.md#Specifying_Ranges Specifying Ranges}
    # @option opts x1 [Integer] (0) the x-coordinate to place. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts y1 [Integer] (0) the y-coordinate to place. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts x2 [Integer] (50) the x-coordinate to place. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts y2 [Integer] (50) the y-coordinate to place. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts stroke_color [String] (:black) the color with which to stroke the line. See {file:README.md#Specifying_Colors___Gradients Specifying Colors & Gradients}.
    # @option opts stroke_width [Decimal] (2.0) the width of the outside stroke. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts stroke_strategy [:fill_first, :stroke_first] (:fill_first) specify whether the stroke is done before (thinner) or after (thicker) filling the shape.
    # @option opts cap [String] ('butt') how the end of the line is drawn. Options are "square", "butt", and "round"
    # @option opts dash [String] ('') define a dash pattern for the stroke. Provide a string with space-separated numbers that define the pattern of on-and-off alternating strokes, measured in pixels by defautl. Supports Unit Conversion, see {file:README.md#Units Units} (e.g. `'0.02in 0.02in'`).
    # @option opts layout [String, Symbol] (nil) entry in the layout to use as defaults for this command. See {file:README.md#Custom_Layouts Custom Layouts}
    # @return [nil] intended to be void
    # @api public
    def line(opts = {})
      range   = Args::CardRange.new(opts[:range], deck_size: size)
      draw    = Args::Draw.new(custom_colors).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      coords  = Args::Coords.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
      range.each { |i| @cards[i].line(coords[i], draw[i]) }
    end

    # Draw a curve using the given coordinates
    #
    # @option opts range [Enumerable, :all] (:all) the range of cards over which this will be rendered. See {file:README.md#Specifying_Ranges Specifying Ranges}
    # @option opts x1 [Integer] (0) the x-coordinate of the first endpoint. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts y1 [Integer] (0) the y-coordinate of the first endpoint. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts x2 [Integer] (50) the x-coordinate of the second endpoint. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts y2 [Integer] (50) the y-coordinate of the second endpoint. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts cx1 [Integer] (0) the x-coordinate of the first control point. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts cy1 [Integer] (0) the y-coordinate of the first control point. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts cx2 [Integer] (50) the x-coordinate of the second control point. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts cy2 [Integer] (50) the y-coordinate of the second control point. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts stroke_color [String] (:black) the color with which to stroke the line. See {file:README.md#Specifying_Colors___Gradients Specifying Colors & Gradients}.
    # @option opts stroke_width [Decimal] (2.0) the width of the outside stroke. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts stroke_strategy [:fill_first, :stroke_first] (:fill_first) specify whether the stroke is done before (thinner) or after (thicker) filling the shape.
    # @option opts fill_color [String] ('#0000') the color with which to fill the triangle. See {file:README.md#Specifying_Colors___Gradients Specifying Colors & Gradients}
    # @option opts cap [String] ('butt') how the end of the line is drawn. Options are "square", "butt", and "round"
    # @option opts dash [String] ('') define a dash pattern for the stroke. Provide a string with space-separated numbers that define the pattern of on-and-off alternating strokes, measured in pixels by defautl. Supports Unit Conversion, see {file:README.md#Units Units} (e.g. `'0.02in 0.02in'`).
    # @option opts layout [String, Symbol] (nil) entry in the layout to use as defaults for this command. See {file:README.md#Custom_Layouts Custom Layouts}
    # @return [nil] intended to be void
    # @api public
    def curve(opts = {})
      range  = Args::CardRange.new(opts[:range], deck_size: size)
      draw   = Args::Draw.new(custom_colors).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      coords = Args::Coords.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
      range.each { |i| @cards[i].curve(coords[i], draw[i]) }
    end

    # Draw a star at the given x,y
    # @example
    #   star x: 10, y: 10, n: 5, angle: Math::PI / 4, inner_radius: 50, outer_radius: 100,
    #        fill_color: :green, stroke_color: :burgundy, :stroke_width: 3
    #
    # @option opts range [Enumerable, :all] (:all) the range of cards over which this will be rendered. See {file:README.md#Specifying_Ranges Specifying Ranges}
    # @option opts x [Fixnum] (0) the x-coordinate of the center. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts y [Fixnum] (0) the y-coordinate of the center. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts n [Integer] (5) the number of points on the star
    # @option opts angle [Fixnum] (0) the angle at which to rotate
    # @option opts inner_radius [Fixnum] (0) the inner radius. Supports Unit conversion.
    # @option opts stroke_color [String] (:black) the color with which to stroke the line. See {file:README.md#Specifying_Colors___Gradients Specifying Colors & Gradients}.
    # @option opts stroke_width [Decimal] (2.0) the width of the outside stroke. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts stroke_strategy [:fill_first, :stroke_first] (:fill_first) specify whether the stroke is done before (thinner) or after (thicker) filling the shape.
    # @option opts fill_color [String] ('#0000') the color with which to fill the triangle. See {file:README.md#Specifying_Colors___Gradients Specifying Colors & Gradients}
    # @option opts dash [String] ('') define a dash pattern for the stroke. Provide a string with space-separated numbers that define the pattern of on-and-off alternating strokes, measured in pixels by defautl. Supports Unit Conversion, see {file:README.md#Units Units} (e.g. `'0.02in 0.02in'`).
    # @option opts layout [String, Symbol] (nil) entry in the layout to use as defaults for this command. See {file:README.md#Custom_Layouts Custom Layouts}
    # @return [nil] intended to be void
    # @api public
    def star(opts = {})
      range  = Args::CardRange.new(opts[:range], deck_size: size)
      draw   = Args::Draw.new(custom_colors).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      coords = Args::Coords.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
      trans  = Args::Transform.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
      range.each { |i| @cards[i].star(coords[i], trans[i], draw[i]) }
    end

    # Draw a regular polygon at the given x,y
    # @example
    #   polygon x: 10, y: 10, n: 5, angle: Math::PI / 4, radius: 50,
    #           fill_color: :green, stroke_color: :burgundy, :stroke_width: 3
    #
    # @option opts range [Enumerable, :all] (:all) the range of cards over which this will be rendered. See {file:README.md#Specifying_Ranges Specifying Ranges}
    # @option opts x [Fixnum] (0) the x-coordinate of the center. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts y [Fixnum] (0) the y-coordinate of the center. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts n [Integer] (5) the number of points on the star
    # @option opts angle [Fixnum] (0) the angle at which to rotate
    # @option opts radius [Fixnum] (0) the radius from center to corner. Supports Unit conversion.
    # @option opts stroke_color [String] (:black) the color with which to stroke the line. See {file:README.md#Specifying_Colors___Gradients Specifying Colors & Gradients}.
    # @option opts stroke_width [Decimal] (2.0) the width of the outside stroke. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts stroke_strategy [:fill_first, :stroke_first] (:fill_first) specify whether the stroke is done before (thinner) or after (thicker) filling the shape.
    # @option opts fill_color [String] ('#0000') the color with which to fill the triangle. See {file:README.md#Specifying_Colors___Gradients Specifying Colors & Gradients}
    # @option opts dash [String] ('') define a dash pattern for the stroke. Provide a string with space-separated numbers that define the pattern of on-and-off alternating strokes, measured in pixels by defautl. Supports Unit Conversion, see {file:README.md#Units Units} (e.g. `'0.02in 0.02in'`).
    # @option opts layout [String, Symbol] (nil) entry in the layout to use as defaults for this command. See {file:README.md#Custom_Layouts Custom Layouts}
    # @return [nil] intended to be void
    # @api public
    def polygon(opts = {})
      range  = Args::CardRange.new(opts[:range], deck_size: size)
      draw   = Args::Draw.new(custom_colors).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      coords = Args::Coords.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
      trans  = Args::Transform.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
      range.each { |i| @cards[i].polygon(coords[i], trans[i], draw[i]) }
    end

  end
end
