require 'forwardable'
require_relative 'gradient_regex'

module Squib
  module Graphics
    # Wrapper class for the Cairo context. Private.
    # @api private
    class CairoContextWrapper
      extend Forwardable

      # :nodoc:
      # @api private
      attr_accessor :cairo_cxt

      # :nodoc:
      # @api private
      def initialize(cairo_cxt)
        @cairo_cxt = cairo_cxt
      end

      def_delegators :cairo_cxt, :save, :set_source_color, :paint, :restore,
        :translate, :rotate, :move_to, :update_pango_layout, :width, :height,
        :show_pango_layout, :rectangle, :rounded_rectangle, :set_line_width,
        :stroke, :fill, :set_source, :scale, :render_rsvg_handle, :circle,
        :triangle, :line_to, :operator=, :show_page, :clip, :transform, :mask,
        :create_pango_layout, :antialias=, :curve_to, :matrix, :matrix=,
        :identity_matrix, :pango_layout_path, :stroke_preserve, :target,
        :new_path, :new_sub_path, :reset_clip, :fill_preserve, :close_path,
        :set_line_join, :set_line_cap, :set_dash, :arc, :arc_negative,
        :pseudo_blur

      # :nodoc:
      # @api private
      def set_source_squibcolor(arg)
        raise 'nil is not a valid color' if arg.nil?
        if match = arg.match(LINEAR_GRADIENT)
          x1, y1, x2, y2 = match.captures
          linear = Cairo::LinearPattern.new(x1.to_f, y1.to_f, x2.to_f, y2.to_f)
          arg.scan(STOPS).each do |color, offset|
            linear.add_color_stop(offset.to_f, color)
          end
          linear.matrix = matrix # match the coordinate systems - see bug 127
          @cairo_cxt.set_source(linear)
        elsif match = arg.match(RADIAL_GRADIENT)
          x1, y1, r1, x2, y2, r2 = match.captures
          radial = Cairo::RadialPattern.new(x1.to_f, y1.to_f, r1.to_f,
                                            x2.to_f, y2.to_f, r2.to_f)
          radial.matrix = matrix # match the coordinate systems - see bug 127
          arg.scan(STOPS).each do |color, offset|
            radial.add_color_stop(offset.to_f, color)
          end
          @cairo_cxt.set_source(radial)
        else
          @cairo_cxt.set_source_color(arg)
        end
      end

      # Convenience method for a common task
      # @api private
      def fill_n_stroke(draw)
        return stroke_n_fill(draw) if draw.stroke_strategy == :stroke_first
        set_source_squibcolor draw.fill_color
        fill_preserve
        set_source_squibcolor draw.stroke_color
        set_line_width draw.stroke_width
        set_line_join draw.join
        set_line_cap draw.cap
        set_dash draw.dash
        stroke
      end

      def stroke_n_fill(draw)
        return fill_n_stroke(draw) if draw.stroke_strategy == :fill_first
        set_source_squibcolor draw.stroke_color
        set_line_width draw.stroke_width
        set_line_join draw.join
        set_line_cap draw.cap
        set_dash draw.dash
        stroke_preserve
        set_source_squibcolor draw.fill_color
        fill
      end

      # Convenience method for a common task
      # @api private
      def fancy_stroke(draw)
        set_source_squibcolor draw.stroke_color
        set_line_width draw.stroke_width
        set_line_join draw.join
        set_line_cap draw.cap
        set_dash draw.dash
        stroke
      end

      def rotate_about(x, y, angle)
        translate(x, y)
        rotate(angle)
        translate(-x, -y)
      end

      # Flip either vertical or horizontal depending
      # From the cairo website: http://cairographics.org/matrix_transform/
      # cairo.Matrix(fx, 0,         0,
      #              fy, cx*(1-fx), cy*(fy-1))
      # fx/fy = 1 means 'no flip', fx/fy = -1 are used for horizontal/vertical flip
      def flip(vertical, horizontal, x, y)
        v = vertical   ? -1.0 : 1.0
        h = horizontal ? -1.0 : 1.0
        transform Cairo::Matrix.new(v, 0.0,     0.0,
                                    h, x * (1 - v), y * (1 - h))
      end

    end
  end
end
