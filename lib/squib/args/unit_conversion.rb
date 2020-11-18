require_relative '../constants'


module Squib
  module Args
    module UnitConversion
      module_function def parse(arg, dpi=300, cell_px=37.5)
        case arg.to_s.rstrip
        when /in$/ # ends with "in"
          arg.rstrip[0..-2].to_f * dpi
        when /pt$/ # ends with "in"
          arg.rstrip[0..-2].to_f * dpi / POINTS_PER_IN
        when /cm$/ # ends with "cm"
          arg.rstrip[0..-2].to_f * dpi * INCHES_IN_CM
        when /mm$/ # ends with "mm"
          arg.rstrip[0..-2].to_f * dpi * INCHES_IN_CM / 10.0
        when /deg$/ # ends with "deg"
          arg.rstrip[0..-3].to_f * (Math::PI / 180.0)
        when /c(ell)?[s]?$/ # ends with 'c', 'cell', or 'cells'
          arg.sub(/c(ell)?[s]?$/, '').to_f * cell_px
        else
          arg
        end
      end
    end
  end
end
