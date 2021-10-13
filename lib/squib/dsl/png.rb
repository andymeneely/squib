require_relative '../errors_warnings/warn_unexpected_params'
require_relative '../args/card_range'
require_relative '../args/paint'
require_relative '../args/scale_box'
require_relative '../args/transform'
require_relative '../args/input_file'

module Squib
  class Deck
    def png(opts = {})
      DSL::PNG.new(self, __callee__).run(opts)
    end
  end

  module DSL
    class PNG
      include WarnUnexpectedParams
      attr_reader :dsl_method, :deck

      def initialize(deck, dsl_method)
        @deck = deck
        @dsl_method = dsl_method
      end

      def self.accepted_params
        %i(
          file
          x y width height
          alpha blend mask angle
          crop_x crop_y crop_width crop_height
          crop_corner_radius crop_corner_x_radius crop_corner_y_radius
          flip_horizontal flip_vertical
          range layout
          placeholder
         )
      end

      def run(opts)
        warn_if_unexpected opts
        Dir.chdir(deck.img_dir) do
          range = Args.extract_range opts, deck
          paint = Args.extract_paint opts, deck
          box   = Args.extract_scale_box opts, deck
          trans = Args.extract_transform opts, deck
          ifile = Args.extract_input_file opts, deck
          deck.progress_bar.start('Loading PNG(s)', range.size) do |bar|
            range.each do |i|
              deck.cards[i].png(ifile[i].file, box[i], paint[i], trans[i])
              bar.increment
            end
          end
        end

      end
    end
  end
end
