require_relative 'arg_loader'

module Squib
  # @api private
  module Args

    class TemplateFile
      include ArgLoader

      def initialize(dsl_method_default = {})
        @dsl_method_default = dsl_method_default
      end

      def self.parameters
        {
          template_file: nil
        }
      end

      def self.expanding_parameters
        []
      end

      def self.params_with_units
        [] # none of them
      end

      def validate_file(arg)
        raise "File #{File.expand_path(arg)} does not exist!" unless arg.nil? File.exists?(arg)
        File.expand_path(arg)
      end

    end

  end
end
