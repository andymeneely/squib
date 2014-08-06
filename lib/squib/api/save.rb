module Squib
  class Deck
  
    # Saves the given range of cards to either PNG or PDF
    #
    # @option opts [Enumerable] range (:all) the range of cards over which this will be rendered. See {file:README.md#Specifying_Ranges Specifying Ranges}
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
    
    # Saves the given range of cards to a PNG 
    #
    # @example
    #   save range: 1..8, dir: '_pnp', prefix: 'bw_'
    #
    # @option opts [Enumerable] range (:all) the range of cards over which this will be rendered. See {file:README.md#Specifying_Ranges Specifying Ranges}
    # @option opts [String] dir (_output) the directory for the output to be sent to. Will be created if it doesn't exist.
    # @option opts [String] prefix (card_) the prefix of the file name to be printed.
    # @return [nil] Returns nothing
    # @api public
    def save_png(opts = {})
      opts = needs(opts,[:range, :creatable_dir, :prefix])
      @progress_bar.start("Saving PNGs to #{opts[:dir]}/#{opts[:prefix]}*") do |bar|
        opts[:range].each do |i| 
          @cards[i].save_png(i, opts[:dir], opts[:prefix])
          bar.increment
        end
      end
    end

  end
end