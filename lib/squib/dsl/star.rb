require_relative '../errors_warnings/warn_unexpected_params'

module Squib
  class Deck
    def star(opts = {})
      DSL::Star.new(self, __callee__).run(opts)
    end
  end

  module DSL
    class Star
      include WarnUnexpectedParams
      attr_reader :dsl_method, :deck

      def initialize(deck, dsl_method)
        @deck = deck
        @dsl_method = dsl_method
      end

      def self.accepted_params
        %i(n x y
           inner_radius outer_radius angle
           fill_color stroke_color stroke_width stroke_strategy join dash cap
           range layout)
      end

      def run(opts)
        warn_if_unexpected opts
        range  = Args.extract_range opts, deck
        draw   = Args.extract_draw opts, deck
        coords = Args.extract_coords opts, deck
        trans  = Args.extract_transform opts, deck
        range.each { |i| deck.cards[i].star(coords[i], trans[i], draw[i]) }
      end
    end
  end
end
