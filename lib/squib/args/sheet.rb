require 'cairo'
require_relative 'arg_loader'
require_relative 'color_validator'
require_relative 'dir_validator'

module Squib::Args
  module_function def extract_sheet(opts, deck, dsl_method_defaults = {})
    Sheet.new(dsl_method_defaults).extract! opts, deck
  end

  class Sheet
    include ArgLoader
    include ColorValidator
    include DirValidator

    def initialize(dsl_method_defaults = {})
      @dsl_method_defaults = dsl_method_defaults
    end

    def self.parameters
      {
        count_format: '%02d',
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
        prefix: 'sheet_',
        suffix: '',
        rows: :infinite,
        columns: 5,
        trim_radius: 0,
        trim: 0,
        width: 3300,
        range: :all,
        rtl: false,
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
        UnitConversion.parse(x, @deck.dpi, @deck.cell_px).to_f
      end
    end

    def validate_crop_marks(arg)
      arg.to_s.downcase.to_sym unless arg == false
    end

    def validate_fill_color(arg)
      colorify(arg, @deck.custom_colors)
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
      count = (range == :all) ? @deck.size : count = range.to_a.length
      return arg.to_i if arg.respond_to? :to_i
      (count.to_f / columns.to_f).ceil # e.g. :infinite
    end

    def full_filename(i=nil)
      if i.nil?
        "#{dir}/#{file}"
      else
        "#{dir}/#{prefix}#{count_format % i}#{suffix}.png"
      end
    end

    def crop_coords(x, y, deck_w, deck_h)
      case crop_marks
      when false
        []
      when :full
        [
          {
            # Vertical, Left
            x1: x + trim + crop_margin_left, y1: 0,
            x2: x + trim + crop_margin_left, y2: height - margin + 1
          },
          {
            # Vertical, Right
            x1: x + deck_w - trim - crop_margin_right, y1: 0,
            x2: x + deck_w - trim - crop_margin_right, y2: height - margin + 1
          },
          {
            # Horizontal, Top
            x1: 0                 , y1: y + trim + crop_margin_top,
            x2: width - margin + 1, y2: y + trim + crop_margin_top
          },
          {
            # Horizontal, Bottom
            x1: 0         , y1: y + deck_h - trim - crop_margin_bottom,
            x2: width - margin + 1, y2: y + deck_h - trim - crop_margin_bottom
          },
        ]
      else # e.g. :margin
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
          { # Horizontal, Upper-left
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
