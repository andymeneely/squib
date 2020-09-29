require_relative '../errors_warnings/warn_unexpected_params'


module Squib
  class Deck
    def save_png(opts = {})
      DSL::SavePNG.new(self, __callee__).run(opts)
    end
  end

  module DSL
    class SavePNG
      include WarnUnexpectedParams
      attr_reader :dsl_method, :deck

      def initialize(deck, dsl_method)
        @deck = deck
        @dsl_method = dsl_method
        @bar = deck.progress_bar
      end

      def self.accepted_params
        %i(
          range
          dir prefix count_format
          rotate trim trim_radius
         )
      end

      def run(opts)
        warn_if_unexpected opts
        Dir.chdir(deck.img_dir) do
          range = Args.extract_range opts, deck
          batch = Args.extract_save_batch opts, deck
          @bar.start("Saving PNGs to #{batch.summary}", deck.size) do |bar|
            range.map do |i|
              deck.cards[i].save_png(batch[i])
              bar.increment
            end

          end
        end

      end
    end
  end
end
