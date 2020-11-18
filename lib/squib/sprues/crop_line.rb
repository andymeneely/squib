module Squib
  module Sprues
    class CropLine
      attr_reader :x1, :y1, :x2, :y2

      def initialize(type, position, sheet_width, sheet_height, dpi, cell_px)
        method = "parse_#{type}"
        send method, position, sheet_width, sheet_height, dpi, cell_px
      end

      def parse_horizontal(position, sheet_width, _, dpi, cell_px)
        position = Args::UnitConversion.parse(position, dpi, cell_px)
        @x1 = 0
        @y1 = position
        @x2 = sheet_width
        @y2 = position
      end

      def parse_vertical(position, _, sheet_height, dpi, cell_px)
        position = Args::UnitConversion.parse(position, dpi, cell_px)
        @x1 = position
        @y1 = 0
        @x2 = position
        @y2 = sheet_height
      end
    end
  end
end
