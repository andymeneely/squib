require_relative '../errors_warnings/warn_unexpected_params'
require_relative '../graphics/save_pdf'
require_relative '../graphics/save_sprue'


module Squib
  class Deck
    def save_pdf(opts = {})
      DSL::SavePDF.new(self, __callee__).run(opts)
    end
  end

  module DSL
    class SavePDF
      include WarnUnexpectedParams
      attr_reader :dsl_method, :deck

      def initialize(deck, dsl_method)
        @deck = deck
        @dsl_method = dsl_method
        @bar = deck.progress_bar
      end

      def self.accepted_params
        %i(
          file dir sprue
          width height margin gap
          crop_marks crop_stroke_color crop_stroke_dash crop_stroke_width
          crop_margin_bottom crop_margin_left crop_margin_right crop_margin_top
          rtl trim trim_radius
          range
         )
      end

      def run(opts)
        warn_if_unexpected opts
        range = Args.extract_range opts, deck
        sheet = Args.extract_sheet opts, deck
        sprue_file = Args.extract_sprue_file opts, deck
        if sprue_file.sprue.nil?
          Graphics::SavePDF.new(deck).render_pdf(range, sheet)
        else
          tmpl = Sprue.load sprue_file.sprue, deck.dpi, deck.cell_px
          Graphics::SaveSpruePDF.new(deck, tmpl, sheet).render_sheet(range)
        end

      end
    end
  end
end
