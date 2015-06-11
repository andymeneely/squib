require 'squib/args/arg_loader'

module Squib
  # @api private
  module Args

    class Tri
      include ArgLoader

      def self.parameters
        { x1: 100, y1: 100,
          x2: 150, y2: 150,
          x3: 100, y3: 150 }
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