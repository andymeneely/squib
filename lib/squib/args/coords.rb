require_relative 'arg_loader'
require_relative 'xywh_shorthands'

module Squib::Args
  module_function def extract_coords(opts, deck)
    Coords.new.extract!(opts, deck)
  end

  class Coords
    include ArgLoader
    include XYWHShorthands

    def self.parameters
      { x: 0,    y: 0,
        x1: 100, y1: 100,
        x2: 150, y2: 150,
        x3: 100, y3: 150,
        cx1: 0 , cy1: 0,
        cx2: 0 , cy2: 0,
        inner_radius: 50, outer_radius: 100,
        radius: 100,
        n: 5,
        arc_start: 0, arc_end: 2 * Math::PI, arc_direction: :clockwise, arc_close: false,
     }
    end

    def self.expanding_parameters
      parameters.keys # all of them
    end

    def self.params_with_units
      parameters.keys # all of them
    end

    def validate_x(arg, i) apply_shorthands(arg, @deck, axis: :x) end
    def validate_y(arg,_i) apply_shorthands(arg, @deck, axis: :y) end
    def validate_x1(arg, i) apply_shorthands(arg, @deck, axis: :x) end
    def validate_y1(arg,_i) apply_shorthands(arg, @deck, axis: :y) end
    def validate_x2(arg, i) apply_shorthands(arg, @deck, axis: :x) end
    def validate_y2(arg,_i) apply_shorthands(arg, @deck, axis: :y)end
    def validate_x3(arg, i) apply_shorthands(arg, @deck, axis: :x) end
    def validate_y3(arg,_i) apply_shorthands(arg, @deck, axis: :y) end
    def validate_cx1(arg, i) apply_shorthands(arg, @deck, axis: :x) end
    def validate_cy1(arg,_i) apply_shorthands(arg, @deck, axis: :y) end
    def validate_cx2(arg, i) apply_shorthands(arg, @deck, axis: :x) end
    def validate_cy2(arg,_i) apply_shorthands(arg, @deck, axis: :y) end
  end

end
