require_relative '../args/card_range'
require_relative '../args/save_batch'
require_relative '../args/sheet'
require_relative '../args/sprue_file'
require_relative '../errors_warnings/warn_unexpected_params'
require_relative '../graphics/save_doc'
require_relative '../graphics/save_sprue'
require_relative '../sprues/sprue'


module Squib
  class Deck
    def save_sheet(opts = {})
      DSL::SaveSheet.new(self, __callee__).run(opts)
    end
  end

  module DSL
    class SaveSheet
      include WarnUnexpectedParams
      attr_reader :dsl_method, :deck

      def initialize(deck, dsl_method)
        @deck = deck
        @dsl_method = dsl_method
      end

      def self.accepted_params
        %i(
          range sprue
          columns rows rtl
          dir prefix count_format suffix
          margin gap trim trim_radius rotate
         )
      end

      def run(opts)
        warn_if_unexpected opts
        range = Args.extract_range opts, deck
        batch = Args.extract_save_batch opts, deck
        sheet = Args.extract_sheet opts, deck, { margin: 0 }
        sprue_file = Args.extract_sprue_file opts, deck
        if sprue_file.sprue.nil?
          deck.render_sheet(range, batch, sheet)
        else
          tmpl = Sprue.load sprue_file.sprue, deck.dpi, deck.cell_px
          Graphics::SaveSpruePNG.new(deck, tmpl, sheet).render_sheet(range)
        end

      end
    end
  end
end
