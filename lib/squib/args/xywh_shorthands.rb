require_relative 'unit_conversion'

module Squib
  module Args
    module XYWHShorthands
      WIDTH_MINUS_REGEX = /^width\s*\-\s*/
      HEIGHT_MINUS_REGEX = /^height\s*\-\s*/
      WIDTH_DIV_REGEX = /^width\s*\/\s*/
      HEIGHT_DIV_REGEX = /^height\s*\/\s*/
      
      # dimension is usually either deck_width or deck_height
      def apply_shorthands(arg, deck, axis: :x)
        dimension = (axis == :x) ? deck.width : deck.height
        arg_s = arg.to_s
        case arg_s
        when 'middle'
          dimension / 2.0
        when 'center'
          dimension / 2.0
        when 'deck'
          dimension
        when WIDTH_MINUS_REGEX # e.g. width - 1.5in
          n = arg_s.sub WIDTH_MINUS_REGEX, ''
          n = UnitConversion.parse(n)
          deck.width - n
        when HEIGHT_MINUS_REGEX # e.g. height - 1.5in
          n = arg_s.sub HEIGHT_MINUS_REGEX, ''
          n = UnitConversion.parse(n)
          deck.height - n
        when WIDTH_DIV_REGEX # e.g. width / 3
          n = (arg_s.sub WIDTH_DIV_REGEX, '').to_f
          deck.width / n
        when HEIGHT_DIV_REGEX # e.g. height / 3
          n = (arg_s.sub HEIGHT_DIV_REGEX, '').to_f
          deck.height / n
        else 
          arg
        end
      end

    end
  end
end