require_relative '../errors_warnings/warn_unexpected_params'

module Squib
  class Deck
    def rect(opts = {})
      DSL::Rect.new(self, __callee__).run(opts)
    end
  end

  module DSL
    class Rect
      include WarnUnexpectedParams
      attr_reader :dsl_method, :deck

      def initialize(deck, dsl_method)
        @deck = deck
        @dsl_method = dsl_method
      end

      def self.accepted_params
        %i(x y width height angle
           x_radius y_radius radius
           fill_color stroke_color stroke_width stroke_strategy join dash cap
           range layout)
      end

      def run(opts)
        warn_if_unexpected opts
        range = Args.extract_range opts, deck
        draw  = Args.extract_draw opts, deck
        box   = Args.extract_box opts, deck
        trans   = Args.extract_transform opts, deck
        range.each { |i| deck.cards[i].rect(box[i], draw[i], trans[i]) }
      end
    end
  end
end
