module Squib
  module Graphics

    class SaveImages
      def initialize(format)
        @format = format
      end

      def execute
        Squib.the_deck.each_with_index do |card, i|
          card.cairo_context.target.write_to_png("_img/img_#{i}.png")
        end
      end
    end

  end
end