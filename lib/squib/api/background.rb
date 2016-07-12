require_relative '../args/card_range'
require_relative '../args/draw'

module Squib
  class Deck

    # DSL method. See http://squib.readthedocs.io
    def background(opts = {})
      range = Args::CardRange.new(opts[:range], deck_size: size)
      draw  = Args::Draw.new(custom_colors).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      range.each { |i| @cards[i].background(draw.color[i]) }
    end

  end
end
