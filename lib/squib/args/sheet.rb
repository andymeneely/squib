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

      def initialize(custom_colors = {}, dsl_method_defaults = {}, deck_size = 1)
        @custom_colors = custom_colors
        @dsl_method_defaults = dsl_method_defaults
        @deck_size = deck_size
      end

      def self.parameters
        {
          dir: '_output',
          file: 'sheet.png',
          fill_color: :white,
          gap: 0,
          height: 2550,
          margin: 75,
          rows: :infinite,
          columns: 5,
          trim_radius: 38,
          trim: 0,
          width: 3300,
        }
      end

      def self.expanding_parameters
        [] # none of them
      end

      def self.params_with_units
        [ :gap, :height, :margin, :trim_radius, :trim, :width ]
      end

      def validate_fill_color(arg)
        colorify(arg, @custom_colors)
      end

      def validate_dir(arg)
        ensure_dir_created(arg)
      end

      def validate_columns(arg)
        raise 'columns must be an integer' unless arg.respond_to? :to_i
        arg.to_i
      end

      def validate_rows(arg)
        raise 'columns must be an integer' unless columns.respond_to? :to_i
        return 1 if @deck_size < columns
        return arg if arg.respond_to? :to_i
        (@deck_size.to_i / columns.to_i).ceil
      end

      def full_filename
        "#{dir}/#{file}"
      end

    end

  end
end
