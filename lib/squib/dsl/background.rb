require_relative '../errors_warnings/warn_unexpected_params'
require_relative '../errors_warnings/error_informant'

module Squib
  class Deck
    include ErrorInformant

    def background(opts = {})
      attempt { DSL::Background.new(self, __callee__).run(opts) }
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
