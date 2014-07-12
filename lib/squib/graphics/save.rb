module Squib
  module Graphics

    class Save
      def initialize(format)
        @format = format
      end

      def execute
        puts "Here!"
        Squib.the_deck.each_with_index do |card, i|
          card.cairo_context.target.write_to_png("_img/img_#{i}.png")
        end
      end
    end

  end
end