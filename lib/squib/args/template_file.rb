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

      def validate_template_file(arg)
        thefile = File.exist?(arg) ? arg: builtin(arg)
        if arg.nil? or not File.exist?(thefile)
          raise "File #{File.expand_path(arg)} does not exist!"
        end

        thefile
      end

      private
      def builtin(file)
        "#{File.dirname(__FILE__)}/../sheet_templates/#{file}"
      end
    end

  end
end
