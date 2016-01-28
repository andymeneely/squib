require 'squib/constants'

module Squib
  module Args
    # :nodoc:
    # @api private
    module UnitConversion

      # :nodoc:
      # @api private
      module_function
      def parse(arg, dpi=300)
        case arg.to_s.rstrip
        when /in$/ #ends with "in"
          arg.rstrip[0..-2].to_f * dpi
        when /cm$/ #ends with "cm"
          arg.rstrip[0..-2].to_f * dpi * INCHES_IN_CM
        else
          arg.to_f
        end
      end

    end
  end
end
