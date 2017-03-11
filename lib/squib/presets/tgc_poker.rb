module Squib
  module Presets
    class TgcPoker

      def initialize(deck)
        @deck = deck
      end

      # The width of the deck to set, unless overridden in Squib.new
      def width
        825
      end

      # The height of the deck to set, unless overridden in Squib.new
      def height
        1125
      end

      # The DPI of the deck to set, unless overridden in Squib.new
      def dpi
        300
      end

      # Executed before the main block
      def before
        @deck.use_layout('tgc_poker.yml')
      end

      def after
        # Nothing here that I can think of yet
      end

      def safe
        @deck.rect layout: :safe
      end

      def cut
        @deck.rect layout: :cut
      end

      def proof
        safe
        cut
      end

    end
  end
end
