require_relative '../errors_warnings/warn_unexpected_params'

module Squib
  class Deck
    def background(opts = {})
      DSL::Background.new(self, __callee__).run(opts)
    end
  end

  module DSL
    class Background
      include WarnUnexpectedParams
      attr_reader :dsl_method, :deck

      def initialize(deck, dsl_method)
        @deck = deck
        @dsl_method = dsl_method
      end

      def self.accepted_params
        %i{
          range
          color
        }
      end

      def run(opts)
        warn_if_unexpected opts
        range = Args.extract_range opts, deck
        draw  = Args.extract_draw opts, deck
        range.each { |i| @deck.cards[i].background(draw.color[i]) }
      end
    end
  end
end
