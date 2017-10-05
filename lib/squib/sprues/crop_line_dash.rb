module Squib
  module Sprues
    class CropLineDash
      VALIDATION_REGEX = /%r{
        ^(\d*[.])?\d+(in|cm|mm)
        \s+
        (\d*[.])?\d+(in|cm|mm)$
      }x/

      attr_reader :pattern

      def initialize(value, dpi)
        if value == :solid
          @pattern = nil
        elsif value == :dotted
          @pattern = [
            Args::UnitConversion.parse('0.2mm', dpi),
            Args::UnitConversion.parse('0.5mm', dpi)
          ]
        elsif value == :dashed
          @pattern = [
            Args::UnitConversion.parse('2mm', dpi),
            Args::UnitConversion.parse('2mm', dpi)
          ]
        elsif value.is_a? String
          @pattern = value.split(' ').map do |val|
            Args::UnitConversion.parse val, dpi
          end
        else
          raise ArgumentError, 'Unsupported dash style'
        end
      end
    end
  end
end
