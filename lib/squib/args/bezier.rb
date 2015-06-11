require 'squib/args/arg_loader'

module Squib
  # @api private
  module Args

    class Bezier
      include ArgLoader

      def self.parameters
        { x1: 100, y1: 100,
          cx1: 0 , cy1: 0,
          x2: 150, y2: 150,
          cx2: 0 , cy2: 0}
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