module Squib
  class Card

    # :nodoc:
    # @api private
    def rect(x, y, width, height, x_radius, y_radius, fill_color, stroke_color, stroke_width)
      width  = @width   if width == :native
      height = @height  if height == :native
      use_cairo do |cc|
        cc.rounded_rectangle(x, y, width, height, x_radius, y_radius)
        cc.set_source_squibcolor(stroke_color)
        cc.set_line_width(stroke_width)
        cc.stroke
        cc.rounded_rectangle(x, y, width, height, x_radius, y_radius)
        cc.set_source_squibcolor(fill_color)
        cc.fill
      end
    end

    # :nodoc:
    # @api private
    def circle(x, y, radius, fill_color, stroke_color, stroke_width)
      use_cairo do |cc|
        cc.move_to(x + radius, y)
        cc.circle(x, y, radius)
        cc.set_source_squibcolor(stroke_color)
        cc.set_line_width(stroke_width)
        cc.stroke
        cc.circle(x, y, radius)
        cc.set_source_squibcolor(fill_color)
        cc.fill
      end
    end

    # :nodoc:
    # @api private
    def triangle(x1, y1, x2, y2, x3, y3, fill_color, stroke_color, stroke_width)
      use_cairo do |cc|
        cc.triangle(x1, y1, x2, y2, x3, y3)
        cc.set_source_squibcolor(stroke_color)
        cc.set_line_width(stroke_width)
        cc.stroke
        cc.triangle(x1, y1, x2, y2, x3, y3)
        cc.set_source_squibcolor(fill_color)
        cc.fill
      end
    end

    # :nodoc:
    # @api private
    def line(x1, y1, x2, y2, stroke_color, stroke_width)
      use_cairo do |cc|
        cc.move_to(x1, y1)
        cc.line_to(x2, y2)
        cc.set_source_squibcolor(stroke_color)
        cc.set_line_width(stroke_width)
        cc.stroke
      end
    end

        # :nodoc:
    # @api private
    def curve(x1, y1, dx1, dy1, x2, y2, dx2, dy2, fill_color, stroke_color, stroke_width)
      use_cairo do |cc|
        cc.move_to(x1, y1)
        cc.curve_to(dx1, dy1, dx2, dy2, x2, y2)
        cc.set_line_width(stroke_width)
        cc.set_source_squibcolor(stroke_color)
        cc.stroke
        cc.move_to(x1, y1)  
        cc.curve_to(dx1, dy1, dx2, dy2, x2, y2)
        cc.set_source_squibcolor(fill_color)
        cc.fill
      end
    end

  end
end
