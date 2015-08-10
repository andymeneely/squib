require 'cairo'
require 'squib/args/arg_loader'
require 'squib/args/color_validator'

module Squib
  # @api private
  module Args

    class Draw
      include ArgLoader
      include ColorValidator

      def initialize(custom_colors, dsl_method_defaults = {})
        @custom_colors = custom_colors
        @dsl_method_defaults = dsl_method_defaults
      end

      def self.parameters
        { color: :black,
          fill_color: '#0000',
          stroke_color: :black,
          stroke_width: 2.0,
          stroke_strategy: :fill_first,
          join: :miter,
          cap: 'butt',
          dash: ''
        }
      end

      def self.expanding_parameters
        parameters.keys # all of them are expandable
      end

      def self.params_with_units
        [:stroke_width]
      end

      def validate_join(arg, _i)
        case arg.to_s.strip.downcase
        when 'miter'
          Cairo::LINE_JOIN_MITER
        when 'round'
          Cairo::LINE_JOIN_ROUND
        when 'bevel'
          Cairo::LINE_JOIN_BEVEL
        end
      end

      def validate_cap(arg, _i)
        case arg.to_s.strip.downcase
        when 'butt'
          Cairo::LINE_CAP_BUTT
        when 'round'
          Cairo::LINE_CAP_ROUND
        when 'square'
          Cairo::LINE_CAP_SQUARE
        end
      end

      def validate_dash(arg, _i)
        arg.to_s.split.collect do |x|
          convert_unit(x, @dpi).to_f
        end
      end

      def validate_fill_color(arg, _i)
        colorify(arg, @custom_colors)
      end

      def validate_stroke_color(arg, _i)
        colorify(arg, @custom_colors)
      end

      def validate_color(arg, _i)
        colorify(arg, @custom_colors)
      end

      def validate_stroke_strategy(arg, _i)
        case arg.to_s.downcase.strip
        when 'fill_first'
          :fill_first
        when 'stroke_first'
          :stroke_first
        else
          raise "Only 'stroke_first' or 'fill_first' allowed"
        end
      end

    end

  end
end
