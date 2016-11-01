require 'cairo'
require_relative 'arg_loader'
require_relative 'color_validator'
require_relative 'dir_validator'

module Squib
  # @api private
  module Args

    class Sheet
      include ArgLoader
      include ColorValidator
      include DirValidator

      def initialize(custom_colors = {}, dsl_method_defaults = {}, deck_size = 1, dpi = 300)
        @custom_colors = custom_colors
        @dsl_method_defaults = dsl_method_defaults
        @deck_size = deck_size
        @dpi = dpi
      end

      def self.parameters
        {
          crop_margin_bottom: 0,
          crop_margin_left: 0,
          crop_margin_right: 0,
          crop_margin_top: 0,
          crop_marks: false,
          crop_stroke_color: :black,
          crop_stroke_dash: '',
          crop_stroke_width: 1.5,
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
        [ :crop_margin_bottom, :crop_margin_left, :crop_margin_right,
          :crop_margin_top, :gap, :height, :margin, :trim_radius, :trim,
          :width
        ]
      end

      def validate_crop_stroke_dash(arg)
        arg.to_s.split.collect do |x|
          UnitConversion.parse(x, @dpi).to_f
        end
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

      def crop_coords(x, y, deck_w, deck_h)
        [
          { # Vertical, Upper-left
            x1: x + trim + crop_margin_left, y1: 0,
            x2: x + trim + crop_margin_left, y2: margin - 1
          },
          { # Vertical , Upper-right
            x1: x + deck_w - trim - crop_margin_right, y1: 0,
            x2: x + deck_w - trim - crop_margin_right, y2: margin - 1
          },
          { # Vertical , Lower-left
            x1: x + trim + crop_margin_left, y1: height,
            x2: x + trim + crop_margin_left, y2: height - margin + 1
          },
          { # Vertical , Lower-right
            x1: x + deck_w - trim - crop_margin_right, y1: height,
            x2: x + deck_w - trim - crop_margin_right, y2: height - margin + 1
          },
          { # Horizont al, Upper-left
            x1: 0         , y1: y + trim + crop_margin_top,
            x2: margin - 1, y2: y + trim + crop_margin_top
          },
          { # Horizontal, Upper-Right
            x1: width             , y1: y + trim + crop_margin_top,
            x2: width - margin + 1, y2: y + trim + crop_margin_top
          },
          { # Horizontal, Lower-Left
            x1: 0         , y1: y + deck_h - trim - crop_margin_bottom,
            x2: margin - 1, y2: y + deck_h - trim - crop_margin_bottom
          },
          { # Horizontal, Lower-Right
            x1: width,              y1: y + deck_h - trim - crop_margin_bottom,
            x2: width - margin + 1, y2: y + deck_h - trim - crop_margin_bottom
          },
        ]
      end

    end

  end
end
