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

    # Ellipse drawing taken from looking at the control points in Inkscape
    # Think of it like a rectangle. Curves go from mid-points of the sides
    # of the rectangle. Control points are at 1/4 and 3/4 of the side.
    # :nodoc:
    # @api private
    def ellipse(x, y, w, h, fill_color, stroke_color, stroke_width)
      use_cairo do |cc|
        cc.move_to(x, y + 0.5*h)       # start west
        cc.curve_to(x, y + 0.25*h,     # west to north
                    x + 0.25*w, y,
                    x +  0.5*w, y)
        cc.curve_to(x + 0.75*w, y,     # north to east
                    x + w, y + 0.25*h,
                    x + w, y + 0.5*h)
        cc.curve_to(x + w, y + 0.75*h, # east to south
                    x + 0.75*w, y + h,
                    x + 0.5*w, y + h)
        cc.curve_to(x + 0.25*w, y + h, # south to west
                    x, y + 0.75*h,
                    x, y + 0.5*h)
        cc.set_source_squibcolor(stroke_color)
        cc.set_line_width(stroke_width)
        cc.stroke_preserve
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
    def curve(x1, y1, cx1, cy1, x2, y2, cx2, cy2, fill_color, stroke_color, stroke_width)
      use_cairo do |cc|
        cc.move_to(x1, y1)
        cc.curve_to(cx1, cy1, cx2, cy2, x2, y2)
        cc.set_line_width(stroke_width)
        cc.set_source_squibcolor(stroke_color)
        cc.stroke
        cc.move_to(x1, y1)
        cc.curve_to(cx1, cy1, cx2, cy2, x2, y2)
        cc.set_source_squibcolor(fill_color)
        cc.fill
      end
    end

    # :nodoc:
    # @api private
    def star(x, y, n, angle, inner_radius, outer_radius, fill_color, stroke_color, stroke_width)
      use_cairo do |cc|
        cc.new_path
        cc.translate(x, y)
        cc.rotate(angle)
        cc.translate(-x, -y)
        cc.move_to(x + outer_radius, y) #i = 0, so 
        theta = Math::PI / n.to_f # i.e. (2*pi) / (2*n)
        0.upto(2 * n) do |i|
            radius = i.even? ? outer_radius : inner_radius
            cc.line_to(x + radius * Math::cos(i * theta),
                       y + radius * Math::sin(i * theta))
        end
        cc.set_source_squibcolor(stroke_color)
        cc.set_line_width(stroke_width)
        cc.fill_preserve
        cc.set_source_squibcolor(fill_color)
        cc.stroke
      end
    end

  end
end
