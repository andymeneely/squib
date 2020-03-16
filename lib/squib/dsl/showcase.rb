require_relative '../errors_warnings/warn_unexpected_params'
require_relative '../args/card_range'
require_relative '../args/showcase_special'
require_relative '../args/sheet'

module Squib
  class Deck
    def showcase(opts = {})
      DSL::Showcase.new(self, __callee__).run(opts)
    end
  end

  module DSL
    class Showcase
      include WarnUnexpectedParams
      attr_reader :dsl_method, :deck

      def initialize(deck, dsl_method)
        @deck = deck
        @dsl_method = dsl_method
      end

      def self.accepted_params
        %i(
          file dir
          trim trim_radius
          scale offset fill_color
          reflect_offset reflect_strength reflect_percent
          face margin
          range
         )
      end

      def run(opts)
        warn_if_unexpected opts
        range = Args.extract_range opts, deck
        showcase = Args.extract_showcase_special opts, deck
        sheet = Args.extract_sheet opts, deck, { file: 'showcase.png' }
        deck.render_showcase(range, sheet, showcase)
      end
    end
  end
end
