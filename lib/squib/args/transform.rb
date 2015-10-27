require 'squib/args/arg_loader'

module Squib
  # @api private
  module Args

    class Transform
      include ArgLoader

      def initialize(deck = nil)
        @deck = deck
      end

      def self.parameters
        { angle: 0,
          crop_x: 0,
          crop_y: 0,
          crop_width: :native,
          crop_height: :native,
          crop_corner_radius: nil,
          crop_corner_x_radius: 0,
          crop_corner_y_radius: 0,
        }
      end

      def self.expanding_parameters
        parameters.keys # all of them
      end

      def self.params_with_units
        parameters.keys # all of them
      end

      def validate_crop_width(arg, _i)
        return arg if @deck.nil?
        return @deck.width if arg == :deck
        arg
      end

      def validate_crop_height(arg, _i)
        return arg if @deck.nil?
        return @deck.height if arg == :deck
        arg
      end

      def validate_crop_corner_x_radius(arg, i)
        return crop_corner_radius[i] unless crop_corner_radius[i].nil?
        arg
      end

      def validate_crop_corner_y_radius(arg, i)
        return crop_corner_radius[i] unless crop_corner_radius[i].nil?
        arg
      end

    end

  end
end