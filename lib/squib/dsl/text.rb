require_relative '../args/box'
require_relative '../args/card_range'
require_relative '../args/draw'
require_relative '../args/paragraph'
require_relative '../args/transform'
require_relative '../dsl/text_embed'
require_relative '../errors_warnings/warn_unexpected_params'

module Squib
  class Deck
    def text(opts = {})
      embed = TextEmbed.new self, __callee__
      yield(embed) if block_given? # store the opts for later use
      DSL::Text.new(self, __callee__, embed).run(opts)
    end
  end

  module DSL
    class Text
      include WarnUnexpectedParams
      attr_reader :dsl_method, :deck, :embed

      def initialize(deck, dsl_method, embed)
        @deck = deck
        @dsl_method = dsl_method
        @embed = embed
      end

      def self.accepted_params
        %i(
          str font font_size x y markup width height
          wrap spacing align justify valign ellipsize angle dash cap join
          hint color fill_color
          stroke_color stroke_width stroke_width stroke_color stroke_strategy
          range layout
        )
      end

      def run(opts)
        warn_if_unexpected opts
        range = Args.extract_range opts, deck
        para  = Args.extract_para opts, deck
        box   = Args.extract_box opts, deck, { width: :auto, height: :auto }
        trans = Args.extract_transform opts, deck
        draw  = Args.extract_draw opts, deck, { stroke_width: 0.0 }
        extents = Array.new(deck.size)
        range.each do |i|
          extents[i] = deck.cards[i].text(embed, para[i], box[i], trans[i], draw[i], deck.dpi)
        end
        return extents
      end
    end
  end
end
