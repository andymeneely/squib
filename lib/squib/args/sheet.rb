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
          dir:          '_output',
          file:         'sheet.png',
          fill_color:   :white,
          gap:          0,
          height:       2550,
          margin_east:  75,
          margin_north: 75,
          margin_south: 75,
          margin_west:  75,
          margin:       :use_individuals,
          rows:         :infinite,
          columns:      5,
          trim_radius:  38,
          trim:         0,
          width:        3300,
        }
      end

      def self.expanding_parameters
        [] # none of them
      end

      def self.params_with_units
        [ :gap, :height, :margin, :margin_north, :margin_south, :margin_east,
          :margin_west, :trim_radius, :trim, :width ]
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

      def validate_margin(arg)
        if arg.respond_to? :to_f
          @margin_east  = arg
          @margin_north = arg
          @margin_south = arg
          @margin_west  = arg
          arg
        else # e.g. :use_individuals
          @margin_north # in case someone just uses margin, not individuals
        end
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

      def compute_width(card_width)
        effective_card_width = card_width + 2 * gap - 2 * trim
        return columns * effective_card_width + margin_west + margin_east
      end

      def compute_height(card_height)
        effective_card_height = card_height + 2 * gap - 2 * trim
        return rows * effective_card_height + margin_north + margin_south
      end

      def upper_left
        [margin_west, margin_north]
      end

    end

  end
end
