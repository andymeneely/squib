require_relative '../args/card_range'
require_relative '../args/hand_special'
require_relative '../args/sheet'
require_relative '../errors_warnings/warn_unexpected_params'
require_relative '../graphics/hand'

module Squib
  class Deck
    def hand(opts = {})
      DSL::Hand.new(self, __callee__).run(opts)
    end
  end

  module DSL
    class Hand
      include WarnUnexpectedParams
      attr_reader :dsl_method, :deck

      def initialize(deck, dsl_method)
        @deck = deck
        @dsl_method = dsl_method
        @bar = deck.progress_bar
      end

      def self.accepted_params
        %i(
          file dir range
          radius angle_range margin fill_color
          trim trim_radius
         )
      end

      def run(opts)
        warn_if_unexpected opts
        range = Args.extract_range opts, deck
        sheet = Args.extract_sheet opts, deck, {file: 'hand.png'}
        hand  = Args.extract_hand_special opts, deck
        deck.render_hand(range, sheet, hand)
      end
    end
  end
end
