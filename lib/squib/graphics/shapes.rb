module Squib
  class Card
      
    # :nodoc:
    # @api private 
    def rect(x, y, width, height, x_radius, y_radius, fill_color, stroke_color, stroke_width)
      width=@width if width==:native; height=@height if height==:native
      cc = cairo_context
      cc.rounded_rectangle(x, y, width, height, x_radius, y_radius)
      cc.set_source_color(stroke_color)
      cc.set_line_width(stroke_width)
      cc.stroke
      cc.rounded_rectangle(x, y, width, height, x_radius, y_radius)
      cc.set_source_color(fill_color)
      cc.fill
    end

    # :nodoc:
    # @api private 
    def circle(x, y, radius, fill_color, stroke_color, stroke_width)
      cc = cairo_context
      cc.circle(x, y, radius)
      cc.set_source_color(stroke_color)
      cc.set_line_width(stroke_width)
      cc.stroke
      cc.circle(x, y, radius)
      cc.set_source_color(fill_color)
      cc.fill
    end
      
  end
end