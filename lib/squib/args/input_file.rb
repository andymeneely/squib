require 'squib/args/arg_loader'

module Squib
  # @api private
  module Args

    class InputFile
      include ArgLoader

      def initialize(dsl_method_default = {})
        @dsl_method_default = dsl_method_default
      end

      def self.parameters
        { file: nil,
          sheet: 0,
        }
      end

      def self.expanding_parameters
        parameters.keys # all of them
      end

      def self.params_with_units
        [] # none of them
      end

      def validate_file(arg, _i)
        return nil if arg.nil?
        raise "File #{File.expand_path(arg)} does not exist!" unless File.exists?(arg)
        File.expand_path(arg)
      end

    end

  end
end
