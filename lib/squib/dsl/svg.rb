require_relative '../errors_warnings/warn_unexpected_params'
require_relative '../args/card_range'
require_relative '../args/paint'
require_relative '../args/scale_box'
require_relative '../args/transform'
require_relative '../args/input_file'
require_relative '../args/svg_special'

module Squib
  class Deck
    def svg(opts = {})
      DSL::SVG.new(self, __callee__).run(opts)
    end
  end

  module DSL
    class SVG
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
          blend mask
          crop_x crop_y crop_width crop_height
          crop_corner_radius crop_corner_x_radius crop_corner_y_radius
          flip_horizontal flip_vertical angle
          id force_id data
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
          svg_args = Args.extract_svg_special opts, deck
          deck.progress_bar.start('Loading PNG(s)', range.size) do |bar|
            range.each do |i|
              if svg_args.render?(i)
                deck.cards[i].svg(ifile[i].file, svg_args[i], box[i], paint[i],
                                  trans[i])
              end
              bar.increment
            end
          end
        end

      end
    end
  end
end
