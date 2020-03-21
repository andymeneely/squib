require_relative '../errors_warnings/warn_unexpected_params'
require_relative '../args/card_range'
require_relative '../args/coords'
require_relative '../args/draw'

module Squib
  class Deck
    def circle(opts = {})
      DSL::Circle.new(self, __callee__).run(opts)
    end
  end

  module DSL
    class Circle
      include WarnUnexpectedParams
      attr_reader :dsl_method, :deck

      def initialize(deck, dsl_method)
        @deck = deck
        @dsl_method = dsl_method
      end

      def self.accepted_params
        %i(x y
           radius arc_start arc_end arc_direction arc_close
           fill_color stroke_color stroke_width stroke_strategy join dash cap
           range layout)
      end

      def run(opts)
        warn_if_unexpected opts
        range = Args.extract_range opts, deck
        coords = Args.extract_coords opts, deck
        draw  = Args.extract_draw opts, deck
        range.each { |i| deck.cards[i].circle(coords[i], draw[i]) }
      end
    end
  end
end
