module Squib
  module Graphics

    class Text
      def initialize(card, str, font, x, y, options)
        @card=card
        @str=str
        @font=font
        @x=x; @y=y
      end

      def execute
        cc = @card.cairo_context
        cc.set_source_rgb(0.0,0.0,0.0)
        cc.select_font_face ("Helvetica");
        cc.set_font_size(36)
        cc.move_to(@x,@y + cc.text_extents(@str.to_s).height)
        cc.show_text(@str.to_s)
      end
    end

  end
end