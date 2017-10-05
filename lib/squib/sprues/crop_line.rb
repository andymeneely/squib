module Squib
  module Sprues
    class CropLine
      attr_reader :x1, :y1, :x2, :y2

      def initialize(type, position, sheet_width, sheet_height, dpi)
        method = "parse_#{type}"
        send method, position, sheet_width, sheet_height, dpi
      end

      def parse_horizontal(position, sheet_width, _, dpi)
        position = Args::UnitConversion.parse(position, dpi)
        @x1 = 0
        @y1 = position
        @x2 = sheet_width
        @y2 = position
      end

      def parse_vertical(position, _, sheet_height, dpi)
        position = Args::UnitConversion.parse(position, dpi)
        @x1 = position
        @y1 = 0
        @x2 = position
        @y2 = sheet_height
      end
    end
  end
end
