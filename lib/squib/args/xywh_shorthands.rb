module Squib
  module Args
    module XYWHShorthands

      def apply_x_shorthands(arg, deck_width)
        arg_s = arg.to_s
        case arg_s
        when 'middle'
          deck_width / 2.0
        when 'center'
          deck_width / 2.0
        when 'deck'
          deck_width
        else 
          arg
        end
      end

      def apply_y_shorthands(arg, deck_height)
        arg_s = arg.to_s
        case arg_s
        when 'middle'
          deck_height / 2.0
        when 'center'
          deck_height / 2.0
        when 'deck'
          deck_height
        else 
          arg
        end
      end

    end
  end
end