require_relative 'unit_conversion'

module Squib
  module Args
    module XYWHShorthands

      MIDDLE_ONLY = /^(middle|center)\s*$/
      DECK_ONLY = /^deck\s*$/
      MIDDLE_MINUS_REGEX = /^(middle|center)\s*\-\s*/
      MIDDLE_PLUS_REGEX = /^(middle|center)\s*\+\s*/
      DECK_MINUS_REGEX = /^deck\s*\-\s*/
      DECK_PLUS_REGEX = /^deck\s*\+\s*/
      DECK_DIV_REGEX = /^deck\s*\/\s*/

      # dimension is usually either deck_width or deck_height
      def apply_shorthands(arg, deck, axis: :x)
        dimension = (axis == :x) ? deck.width : deck.height
        arg_s = arg.to_s
        case arg_s
        when MIDDLE_ONLY
          dimension / 2.0
        when DECK_ONLY
          dimension
        when MIDDLE_MINUS_REGEX # e.g. width: middle - 3
          n = arg_s.sub MIDDLE_MINUS_REGEX, ''
          n = UnitConversion.parse(n, deck.dpi, deck.cell_px).to_f
          dimension / 2.0 - n
        when MIDDLE_PLUS_REGEX # e.g. middle + 1.5in
          n = arg_s.sub MIDDLE_PLUS_REGEX, ''
          n = UnitConversion.parse(n, deck.dpi, deck.cell_px).to_f
          dimension / 2.0 + n
        when DECK_MINUS_REGEX # e.g. width: deck - 1.5in
          n = arg_s.sub DECK_MINUS_REGEX, ''
          n = UnitConversion.parse(n, deck.dpi, deck.cell_px).to_f
          dimension - n
        when DECK_PLUS_REGEX # e.g. deck + 1.5in (which is weird but ok)
          n = arg_s.sub DECK_PLUS_REGEX, ''
          n = UnitConversion.parse(n, deck.dpi, deck.cell_px).to_f
          dimension + n
        when DECK_DIV_REGEX # e.g. width: deck/3
          n = arg_s.sub DECK_DIV_REGEX, ''
          n = UnitConversion.parse(n, deck.dpi, deck.cell_px).to_f
          dimension / n
        else
          arg
        end
      end

    end
  end
end