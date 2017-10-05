require_relative 'text_embed'
require_relative '../args/box'
require_relative '../args/card_range'
require_relative '../args/draw'
require_relative '../args/paragraph'

module Squib
  class Deck

    # DSL method. See http://squib.readthedocs.io
    def text(opts = {})
      range = Args::CardRange.new(opts[:range], deck_size: size)
      para  = Args::Paragraph.new(font).load!(opts, expand_by: size, layout: layout)
      box   = Args::Box.new(self, { width: :auto, height: :auto }).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      trans = Args::Transform.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
      draw  = Args::Draw.new(custom_colors, { stroke_width: 0.0 }).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      embed = TextEmbed.new(size, custom_colors, layout, dpi, img_dir)
      yield(embed) if block_given? # store the opts for later use
      extents = Array.new(@cards.size)
      range.each { |i| extents[i] = @cards[i].text(embed, para[i], box[i], trans[i], draw[i], dpi) }
      return extents
    end

  end
end
