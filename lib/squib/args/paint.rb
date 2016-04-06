require 'cairo'
require_relative 'arg_loader'
require_relative 'color_validator'

module Squib
  # @api private
  module Args
    class Paint
      include ArgLoader
      include ColorValidator

      def self.parameters
        { alpha: 1.0,
          blend: :none,
          mask:  nil,
        }
      end


      def self.expanding_parameters
        parameters.keys # all of them are expandable
      end

      def self.params_with_units
        []
      end

      def initialize(custom_colors)
        @custom_colors = custom_colors
      end

      def validate_alpha(arg, _i)
        raise 'alpha must respond to to_f' unless arg.respond_to? :to_f
        arg.to_f
      end

      def validate_mask(arg, _i)
        colorify(arg, @custom_colors)
      end


    end
  end
end
