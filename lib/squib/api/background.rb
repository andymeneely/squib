module Squib
  class Deck
    # Fills the background with the given color
    # @example
    #   background color: :white
    #
    # Options support Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    #
    # @option opts range [Enumerable] (:all) the range of cards over which this will be rendered. See {file:README.md#Specifying_Ranges Specifying Ranges}
    # @option opts color [String] (:black) the color the font will render to. See {file:README.md#Specifying_Colors___Gradients Specifying Colors & Gradients}.
    # @return [nil] nothing
    # @api public
    def background(opts = {})
      range = Args::CardRange.new(opts[:range], deck_size: size)
      draw  = Args::Draw.new(custom_colors).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      range.each { |i| @cards[i].background(draw.color[i]) }
    end

  end
end
