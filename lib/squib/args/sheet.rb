require 'cairo'
require 'squib/args/arg_loader'
require 'squib/args/color_validator'
require 'squib/args/dir_validator'

module Squib
  # @api private
  module Args

    class Sheet
      include ArgLoader
      include ColorValidator
      include DirValidator

      def initialize(custom_colors = {}, dsl_method_defaults = {})
        @custom_colors = custom_colors
        @dsl_method_defaults = dsl_method_defaults
      end

      def self.parameters
        { dir: '_output',
          file: 'sheet.png',
          fill_color: :white,
          gap: 0,
          margin: 75,
          trim_radius: 38,
          trim: 0,
        }
      end

      def self.expanding_parameters
        [] # none of them
      end

      def self.params_with_units
        [ :gap, :margin, :trim_radius, :trim ]
      end

      def validate_fill_color(arg)
        colorify(arg, @custom_colors)
      end

      def validate_dir(arg)
        ensure_dir_created(arg)
      end

    end

  end
end
