require_relative 'arg_loader'

module Squib
  # @api private
  module Args

    class Box
      include ArgLoader

      def initialize(deck = nil, dsl_method_defaults = {})
        @deck = deck
        @dsl_method_defaults = dsl_method_defaults
      end

      def self.parameters
        { x: 0, y: 0,
          width: :deck, height: :deck,
          radius: nil, x_radius: 0, y_radius: 0
        }
      end

      def self.expanding_parameters
        parameters.keys # all of them
      end

      def self.params_with_units
        parameters.keys # all of them
      end

      def validate_width(arg, _i)
        return arg if @deck.nil?
        return @deck.width if arg == :deck
        arg
      end

      def validate_height(arg, _i)
        return arg if @deck.nil?
        return @deck.height if arg == :deck
        arg
      end

      def validate_x_radius(arg, i)
        return radius[i] unless radius[i].nil?
        arg
      end

      def validate_y_radius(arg, i)
        return radius[i] unless radius[i].nil?
        arg
      end

    end

  end
end