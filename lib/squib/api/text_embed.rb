require_relative '../args/box'
require_relative '../args/card_range'
require_relative '../args/embed_adjust'
require_relative '../args/embed_key'
require_relative '../args/input_file'
require_relative '../args/paint'
require_relative '../args/transform'

module Squib
  class TextEmbed
    # :nodoc:
    # @api private
    attr_reader :rules

    # :nodoc:
    # @api private
    def initialize(deck_size, custom_colors, layout, dpi, img_dir)
      @deck_size     = deck_size
      @custom_colors = custom_colors
      @layout        = layout
      @dpi           = dpi
      @img_dir       = img_dir
      @rules = {} # store an array of options for later usage
    end

    # DSL method. See http://squib.readthedocs.io
    def svg(opts = {})
      key   = Args::EmbedKey.new.validate_key(opts[:key])
      range = Args::CardRange.new(opts[:range], deck_size: @deck_size)
      paint = Args::Paint.new(@custom_colors).load!(opts, expand_by: @deck_size, layout: @layout)
      box   = Args::Box.new(self, { width: :native, height: :native }).load!(opts, expand_by: @deck_size, layout: @layout, dpi: @dpi)
      adjust = Args::EmbedAdjust.new.load!(opts, expand_by: @deck_size, layout: @layout, dpi: @dpi)
      trans = Args::Transform.new.load!(opts, expand_by: @deck_size, layout: @layout, dpi: @dpi)
      ifile = Args::InputFile.new.load!(opts, expand_by: @deck_size, layout: @layout, dpi: @dpi)
      svg_args = Args::SvgSpecial.new.load!(opts, expand_by: @deck_size, layout: @layout, dpi: @dpi)
      rule = { type: :svg, file: ifile, box: box, paint: paint, trans: trans,
               adjust: adjust, svg_args: svg_args }
      rule[:draw] = Proc.new do |card, x, y|
        i = card.index
        b = box[i]
        b.x, b.y = x, y
        Dir.chdir(@img_dir) do
          card.svg(ifile[i].file, svg_args[i], b, paint[i], trans[i])
        end
      end
      @rules[key] = rule
    end

    # DSL method. See http://squib.readthedocs.io
    def png(opts = {})
      key   = Args::EmbedKey.new.validate_key(opts[:key])
      range = Args::CardRange.new(opts[:range], deck_size: @deck_size)
      paint = Args::Paint.new(@custom_colors).load!(opts, expand_by: @deck_size, layout: @layout)
      box   = Args::Box.new(self, { width: :native, height: :native }).load!(opts, expand_by: @deck_size, layout: @layout, dpi: @dpi)
      adjust = Args::EmbedAdjust.new.load!(opts, expand_by: @deck_size, layout: @layout, dpi: @dpi)
      trans = Args::Transform.new.load!(opts, expand_by: @deck_size, layout: @layout, dpi: @dpi)
      ifile = Args::InputFile.new.load!(opts, expand_by: @deck_size, layout: @layout, dpi: @dpi)
      rule  = { type: :png, file: ifile, box: box, paint: paint, trans: trans, adjust: adjust }
      rule[:draw] = Proc.new do |card, x, y|
        i = card.index
        b = box[i]
        b.x, b.y = x, y
        Dir.chdir(@img_dir) do
          card.png(ifile[i].file, b, paint[i], trans[i])
        end
      end
      @rules[key] = rule
    end

  end
end
