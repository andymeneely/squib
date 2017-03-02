require_relative 'arg_loader'

module Squib
  # @api private
  module Args

    class Coords
      include ArgLoader

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

    end

  end
end
