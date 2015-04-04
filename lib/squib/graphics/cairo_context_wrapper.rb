require 'forwardable'
require 'squib/graphics/gradient_regex'

module Squib
  module Graphics
    # Wrapper class for the Cairo context. Private.
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
        :show_pango_layout, :rounded_rectangle, :set_line_width, :stroke, :fill,
        :set_source, :scale, :render_rsvg_handle, :circle, :triangle, :line_to,
        :operator=, :show_page, :clip, :transform, :mask, :create_pango_layout,
        :antialias=, :curve_to, :matrix, :matrix=, :identity_matrix

      # :nodoc:
      # @api private
      def set_source_squibcolor(arg)
        if match = arg.match(LINEAR_GRADIENT)
          x1, y1, x2, y2 = match.captures
          linear = Cairo::LinearPattern.new(x1.to_f, y1.to_f, x2.to_f, y2.to_f)
          arg.scan(STOPS).each do |color, offset|
            linear.add_color_stop(offset.to_f, color)
          end
          @cairo_cxt.set_source(linear)
        elsif match = arg.match(RADIAL_GRADIENT)
          x1, y1, r1, x2, y2, r2  = match.captures
          linear = Cairo::RadialPattern.new(x1.to_f, y1.to_f, r1.to_f,
                                            x2.to_f, y2.to_f, r2.to_f)
          arg.scan(STOPS).each do |color, offset|
            linear.add_color_stop(offset.to_f, color)
          end
          @cairo_cxt.set_source(linear)
        else
          @cairo_cxt.set_source_color(arg)
        end
      end
    end
  end
end