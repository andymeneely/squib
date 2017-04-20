require_relative '../constants'

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
        when /in$/ # ends with "in"
          arg.rstrip[0..-2].to_f * dpi
        when /pt$/ # ends with "in"
          arg.rstrip[0..-2].to_f * dpi / POINTS_PER_IN
        when /cm$/ # ends with "cm"
          arg.rstrip[0..-2].to_f * dpi * INCHES_IN_CM
        when /mm$/ # ends with "mm"
          arg.rstrip[0..-2].to_f * dpi * INCHES_IN_CM / 10.0
        else
          arg
        end
      end

    end
  end
end
