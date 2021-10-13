require_relative '../args/box'
require_relative '../args/card_range'
require_relative '../args/embed_adjust'
require_relative '../args/embed_key'
require_relative '../args/input_file'
require_relative '../args/paint'
require_relative '../args/transform'
require_relative '../errors_warnings/warn_unexpected_params'

module Squib
  class TextEmbed
    include WarnUnexpectedParams
    attr_reader :rules, :deck, :dsl_method

    def initialize(deck, dsl_method)
      @deck = deck
      @rules = {} # store an array of options for later usage
    end

    def self.accepted_params
      %i(
        key file id force_id layout width height dx dy
        id force_id data
        flip_horizontal flip_vertical
        alpha angle blend mask
        placeholder
      )
    end

    def svg(opts = {})
      warn_if_unexpected opts
      key   = Args::EmbedKey.new.validate_key(opts[:key])
      range = Args.extract_range opts, deck
      paint = Args.extract_paint opts, deck
      box   = Args.extract_box opts, deck, { width: :native, height: :native }
      adjust = Args::EmbedAdjust.new.load!(opts, expand_by: deck.size, layout: deck.layout, dpi: deck.dpi)
      trans = Args.extract_transform opts, deck
      ifile = Args.extract_input_file opts, deck
      svg_args = Args.extract_svg_special opts, deck
      rule = { type: :svg, file: ifile, box: box, paint: paint, trans: trans,
               adjust: adjust, svg_args: svg_args }
      rule[:draw] = Proc.new do |card, x, y, scale|
        i = card.index
        b = box[i]
        b.x, b.y = x, y
        b.width = b.width * scale if b.width.is_a? Numeric
        b.height = b.height * scale if b.height.is_a? Numeric
        Dir.chdir(deck.img_dir) do
          card.svg(ifile[i].file, svg_args[i], b, paint[i], trans[i])
        end
      end
      @rules[key] = rule
    end

    def png(opts = {})
      warn_if_unexpected opts
      key   = Args::EmbedKey.new.validate_key(opts[:key])
      range = Args.extract_range opts, deck
      paint = Args.extract_paint opts, deck
      box   = Args.extract_box opts, deck, { width: :native, height: :native }
      adjust = Args::EmbedAdjust.new.load!(opts, expand_by: deck.size, layout: deck.layout, dpi: deck.dpi)
      trans = Args.extract_transform opts, deck
      ifile = Args.extract_input_file opts, deck
      rule  = { type: :png, file: ifile, box: box, paint: paint, trans: trans, adjust: adjust }
      rule[:draw] = Proc.new do |card, x, y, scale|
        i = card.index
        b = box[i]
        b.x, b.y = x, y
        b.width = b.width * scale if b.width.is_a? Numeric
        b.height = b.height * scale if b.height.is_a? Numeric
        Dir.chdir(deck.img_dir) do
          card.png(ifile[i].file, b, paint[i], trans[i])
        end
      end
      @rules[key] = rule
    end

  end
end
