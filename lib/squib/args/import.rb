require 'squib/args/arg_loader'

module Squib
  # @api private
  module Args

    class Import
      include ArgLoader

      def self.parameters
        { strip: true,
          explode: 'Qty'
        }
      end

      def self.expanding_parameters
        [] # none of them
      end

      def self.params_with_units
        [] # none of them
      end

      def validate_strip(arg)
        raise 'Strip must be true or false' unless arg == true || arg == false
        arg
      end

      def validate_explode(arg)
        arg
      end

      def strip?
        strip
      end

    end

  end
end