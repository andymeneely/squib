require_relative '../errors_warnings/warn_unexpected_params'

module Squib
  class Deck
    def grid(opts = {})
      DSL::Grid.new(self, __callee__).run(opts)
    end
  end

  module DSL
    class Grid
      include WarnUnexpectedParams
      attr_reader :dsl_method, :deck

      def initialize(deck, dsl_method)
        @deck = deck
        @dsl_method = dsl_method
      end

      def self.accepted_params
        %i(x y width height
           fill_color stroke_color stroke_width stroke_strategy dash cap
           range layout)
      end

      def run(opts)
        warn_if_unexpected opts
        range = Args.extract_range opts, deck
        draw  = Args.extract_draw opts, deck
        box   = Args.extract_box opts, deck
        range.each { |i| deck.cards[i].grid(box[i], draw[i]) }
      end
    end
  end
end
