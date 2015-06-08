require 'squib/args/arg_loader'

module Squib
  # @api private
  module Args

    class Draw
      include ArgLoader

      def self.parameters
        { fill_color: '#0000', stroke_color: :black, stroke_width: 2.0 }
      end

      def self.expanding_parameters
        parameters.keys # all of them are expandable
      end

      def self.params_with_units
        [:stroke_width]
      end

    end

  end
end