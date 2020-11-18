module Squib
  module Sprues
    class CropLineDash
      VALIDATION_REGEX = /%r{
        ^(\d*[.])?\d+(in|cm|mm)
        \s+
        (\d*[.])?\d+(in|cm|mm)$
      }x/

      attr_reader :pattern

      def initialize(value, dpi, cell_px)
        if value == :solid
          @pattern = nil
        elsif value == :dotted
          @pattern = [
            Args::UnitConversion.parse('0.2mm', dpi, cell_px),
            Args::UnitConversion.parse('0.5mm', dpi, cell_px)
          ]
        elsif value == :dashed
          @pattern = [
            Args::UnitConversion.parse('2mm', dpi, cell_px),
            Args::UnitConversion.parse('2mm', dpi, cell_px)
          ]
        elsif value.is_a? String
          @pattern = value.split(' ').map do |val|
            Args::UnitConversion.parse val, dpi, cell_px
          end
        else
          raise ArgumentError, 'Unsupported dash style'
        end
      end
    end
  end
end
