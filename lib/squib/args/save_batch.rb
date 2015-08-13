require 'squib/args/arg_loader'

module Squib
  # @api private
  module Args
    class SaveBatch
      include ArgLoader

      def initialize
      end

      def self.parameters
        { dir: '_output',
          prefix: 'card_',
          count_format: '%02d',
          rotate: false,
          angle: 0,
        }
      end

      def self.expanding_parameters
        self.parameters.keys # all of them
      end

      def self.params_with_units
        [] # none of them
      end

      def validate_dir(arg, _i)
        unless Dir.exists?(arg)
          Squib.logger.warn("Dir '#{arg}' does not exist, creating it.")
          Dir.mkdir arg
        end
        return arg
      end

      def validate_rotate(arg, i)
        case arg
        when true, :clockwise
          angle[i] = 0.5 * Math::PI
          return true
        when :counterclockwise
          angle[i] = 1.5 * Math::PI
          return true
        when false
          false
        else
          raise 'invalid option to rotate: only [true, false, :clockwise, :counterclockwise]'
        end
      end

    end
  end
end
