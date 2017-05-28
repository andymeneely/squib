require_relative 'arg_loader'
require_relative 'dir_validator'

module Squib
  # @api private
  module Args
    class OutputFile
      include ArgLoader
      include DirValidator

      def initialize(dpi = 300)
        @dpi = 300
      end

      def self.parameters
        {
          dir: '_output',
          file: 'output.pdf'
        }
      end

      def self.expanding_parameters
        [] # none of them
      end

      def self.params_with_units
        []
      end

      def validate_dir(arg)
        ensure_dir_created(arg)
      end

      def full_filename
        "#{dir}/#{file}"
      end

    end
  end
end
