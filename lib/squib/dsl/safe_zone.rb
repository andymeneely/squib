require_relative '../errors_warnings/warn_unexpected_params'

module Squib
  class Deck
    def safe_zone(opts = {})
      DSL::SafeZone.new(self, __callee__).run(opts)
    end
  end

  module DSL
    class SafeZone
      include WarnUnexpectedParams
      attr_reader :dsl_method, :deck

      def initialize(deck, dsl_method)
        @deck = deck
        @dsl_method = dsl_method
      end

      def self.accepted_params
        %i(x y width height margin angle
           x_radius y_radius radius
           fill_color stroke_color stroke_width stroke_strategy join dash cap
           range layout)
      end

      def run(opts)
        warn_if_unexpected opts
        safe_defaults = {
          margin: '0.25in',
          radius: '0.125in',
          stroke_color: :blue,
          fill_color: '#0000',
          stroke_width: 1.0,
          dash: '3 3',
        }
        new_opts = safe_defaults.merge(opts)
        margin = Args::UnitConversion.parse new_opts[:margin], @deck.dpi, @deck.cell_px
        new_opts[:x] = margin
        new_opts[:y] = margin
        new_opts[:width] = deck.width - (2 * margin)
        new_opts[:height] = deck.height - (2 * margin)
        new_opts.delete :margin
        deck.rect(new_opts)
      end
    end
  end
end
