require 'squib/args/arg_loader'

module Squib
  # @api private
  module Args

    class Polygon
      include ArgLoader

      def self.parameters
        { x: 0, y: 0, n: 5,
          radius: 100, inner_radius: 50, outer_radius: 100}
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