module Squib
  # @api private
  class Card

    # :nodoc:
    # @api private
    def rect(box, draw, trans)
      use_cairo do |cc|
        cc.rotate_about(box.x, box.y, trans.angle)
        cc.rounded_rectangle(box.x, box.y, box.width, box.height,
                             box.x_radius, box.y_radius)
        cc.fill_n_stroke(draw)
      end
    end

    # :nodoc:
    # @api private
    def circle(box, draw)
      x, y, r = box.x, box.y, box.radius
      use_cairo do |cc|
        if box.arc_direction == :clockwise
          cc.arc(x, y, r, box.arc_start, box.arc_end)          
        else
          cc.arc_negative(x, y, r, box.arc_start, box.arc_end)
        end
        if box.arc_close
          cc.close_path();
        end
        cc.fill_n_stroke(draw)
      end
    end

    # Ellipse drawing taken from looking at the control points in Inkscape
    # Think of it like a rectangle. Curves go from mid-points of the sides
    # of the rectangle. Control points are at 1/4 and 3/4 of the side.
    # :nodoc:
    # @api private
    def ellipse(box, draw, trans)
      x, y, w, h = box.x, box.y, box.width, box.height
      use_cairo do |cc|
        cc.rotate_about(box.x, box.y, trans.angle)
        cc.move_to(x, y + 0.5 * h)       # start west
        cc.curve_to(x, y + 0.25 * h,     # west to north
                    x + 0.25 * w, y,
                    x + 0.5 * w, y)
        cc.curve_to(x + 0.75 * w, y,     # north to east
                    x + w, y + 0.25 * h,
                    x + w, y + 0.5 * h)
        cc.curve_to(x + w, y + 0.75 * h, # east to south
                    x + 0.75 * w, y + h,
                    x + 0.5 * w, y + h)
        cc.curve_to(x + 0.25 * w, y + h, # south to west
                    x, y + 0.75 * h,
                    x, y + 0.5 * h)
        cc.fill_n_stroke(draw)
      end
    end

    # :nodoc:
    # @api private
    def grid(box, draw)
      x, y, w, h = box.x, box.y, box.width, box.height
      use_cairo do |cc|
        (x..@width + w).step(w)  { |ix| line_xy(ix, y - @height, ix, @height + y, draw) }
        (y..@height + h).step(h) { |iy| line_xy(x - @width, iy, @width + x, iy, draw) }
      end
    end

    # :nodoc:
    # @api private
    def triangle(tri, draw)
      use_cairo do |cc|
        cc.triangle(tri.x1, tri.y1, tri.x2, tri.y2, tri.x3, tri.y3)
        cc.fill_n_stroke(draw)
      end
    end

    # :nodoc:
    # @api private
    def line(coord, draw)
      line_xy(coord.x1, coord.y1, coord.x2, coord.y2, draw)
    end

    # :nodoc:
    # @api private
    def line_xy(x1, y1, x2, y2, draw)
      use_cairo do |cc|
        cc.move_to(x1, y1)
        cc.line_to(x2, y2)
        cc.fancy_stroke(draw)
      end
    end

        # :nodoc:
    # @api private
    def curve(bez, draw)
      x1, y1, cx1, cy1 = bez.x1, bez.y1, bez.cx1, bez.cy1
      cx2, cy2, x2, y2 = bez.cx2, bez.cy2, bez.x2, bez.y2
      use_cairo do |cc|
        cc.move_to(x1, y1)
        cc.curve_to(cx1, cy1, cx2, cy2, x2, y2)
        cc.fill_n_stroke(draw)
      end
    end

    # :nodoc:
    # @api private
    def star(poly, trans, draw)
      x, y, n = poly.x, poly.y, poly.n
      inner_radius, outer_radius = poly.inner_radius, poly.outer_radius
      use_cairo do |cc|
        cc.rotate_about(x, y, trans.angle)
        cc.move_to(x + outer_radius, y) # i = 0, so cos(0)=1 and sin(0)=0
        theta = Math::PI / n.to_f # i.e. (2*pi) / (2*n)
        0.upto(2 * n) do |i|
            radius = i.even? ? outer_radius : inner_radius
            cc.line_to(x + radius * Math::cos(i * theta),
                       y + radius * Math::sin(i * theta))
        end
        cc.close_path
        cc.fill_n_stroke(draw)
      end
    end

    # :nodoc:
    # @api private
    def polygon(poly, trans, draw)
      x, y, n, radius = poly.x, poly.y, poly.n, poly.radius
      use_cairo do |cc|
        cc.rotate_about(x, y, trans.angle)
        cc.move_to(x + radius, y) # i = 0, so cos(0)=1 and sin(0)=0
        theta = (2 * Math::PI) / n.to_f
        0.upto(n) do |i|
            cc.line_to(x + radius * Math::cos(i * theta),
                       y + radius * Math::sin(i * theta))
        end
        cc.close_path
        cc.fill_n_stroke(draw)
      end
    end

  end
end
