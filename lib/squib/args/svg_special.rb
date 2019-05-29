require_relative 'arg_loader'

module Squib
  # @api private
  module Args

    class SvgSpecial
      include ArgLoader

      def self.parameters
        { data: nil, id: nil, force_id: false }
      end

      def self.expanding_parameters
        parameters.keys # all of them
      end

      def self.params_with_units
        []
      end

      def validate_id(arg, _i)
        return nil if arg.to_s.empty?
        arg = '#' << arg unless arg.start_with? '#'
        arg
      end

      # Only render if we have an ID specified, or we are forcing an ID
      def render?(i)
        return false if force_id[i] && id[i].to_s.empty?
        return true
      end

    end

  end
end
