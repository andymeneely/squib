require 'squib/args/unit_conversion'
require 'squib/args/vendor_args'
module Squib
  # @api private
  module Args
    module Bleed

      def self.add value, bleed, dpi
        Args::UnitConversion.parse(value, dpi) + (2 * Args::UnitConversion.parse(bleed, dpi))
      end

      def self.size(card, height, width, dpi)
        dimentions =  Args::VendorArgs.base_options(card)
        cut_height = Args::UnitConversion.parse dimentions[:height], dpi
        cut_width = Args::UnitConversion.parse dimentions[:width], dpi
        unless (width - cut_width) - (height - cut_height) < 0.1
          Squib::Logger.warn "Cannot deternmine bleed; X and Y bleed are uneven."
          return 0;
        end
        return (height - cut_height) / 2
      end

    end
  end
end
