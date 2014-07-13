module Squib
  module Graphics

    class Background
      def initialize(card, color)
        @card=card; @color=color
      end

      def execute
        cc = @card.cairo_context
        cc.set_source_rgb(*@color)
        cc.paint
      end
    end

  end
end