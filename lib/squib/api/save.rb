module Squib
  class Deck
  
    # Saves the given range of cards to either PNG or PDF
    #
    # @option opts [Enumerable] range (:all) the range of cards over which this will be rendered. See {file:API.md#label-Specifying+Ranges Specifying Ranges}
    # @option opts [String] dir (_output) the directory for the output to be sent to. Will be created if it doesn't exist.
    # @option opts [Symbol] format (:png)  the format that this will be rendered too. Options `:pdf, :png`. Array of both is allowed: `[:pdf, :png]`
    # @option opts [String] prefix (card_) the prefix of the file name to be printed
    # @return self
    # @api public
    def save(opts = {})
      opts = needs(opts, [:range, :creatable_dir, :formats, :prefix])
      save_png(opts) if opts[:format].include? :png
      save_pdf(opts) if opts[:format].include? :pdf
      self
    end
    
    # Saves the given range of cards to PNG 
    #
    # @option opts [Enumerable] range (:all) the range of cards over which this will be rendered. See {file:API.md#label-Specifying+Ranges Specifying Ranges}
    # @option opts [String] dir (_output) the directory for the output to be sent to. Will be created if it doesn't exist.
    # @option opts [String] prefix (card_) the prefix of the file name to be printed.
    def save_png(opts = {})
      opts = needs(opts,[:range, :creatable_dir, :prefix])
      opts[:range].each do |i| 
        @cards[i].save_png(i, opts[:dir], opts[:prefix])
      end
    end

  end
end