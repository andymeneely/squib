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

      def accepted_params
        %i{
          range
          color
        }
      end

      def run(opts)
        warn_if_unexpected opts
        range = Args::CardRange.new(opts[:range], deck_size: deck.size)
        draw  = Args::Draw.new(@deck.custom_colors).extract!(opts, deck)
        range.each { |i| @deck.cards[i].background(draw.color[i]) }
      end
    end
  end
end
