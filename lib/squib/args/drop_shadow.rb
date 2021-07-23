require_relative 'color_validator'

module Squib::Args
  module_function def extract_drop_shadow(opts, deck)
    DropShadow.new(deck.custom_colors).extract! opts, deck
  end

  class DropShadow
    include ArgLoader
    include ColorValidator

    def initialize(custom_colors)
      @custom_colors = custom_colors
    end

    def self.parameters
      {
        shadow_color: :black,
        shadow_offset_x: 3,
        shadow_offset_y: 3,
        shadow_radius: nil,
        shadow_trim: 0,
      }
    end

    def self.expanding_parameters
      self.parameters.keys # all of them
    end

    def self.params_with_units
      [:shadow_offset_x, :shadow_offset_y, :shadow_radius, :shadow_trim]
    end

    def validate_shadow_color(arg, _i)
      colorify(arg, @custom_colors)
    end

  end
end
