module Squib
  class Deck
  
    # Saves the range of cards to either PNG or PDF
    #
    # @param range: the range of cards over which this will be rendered. See {file:API.md#label-Specifying+Ranges Specifying Ranges}
    # @param dir: the directory for the output to be sent to. Will be created if it doesn't exist
    # @param format: the format that this will be rendered too. Options `:pdf, :png`. Array of both is allowed: `[:pdf, :png]`
    # @param prefix: the prefix of the file name to be printed
    def save(range: :all, dir: "_output", format: :png, prefix: "card_")
      format = [format].flatten
      save_png(range: range, dir: dir, prefix: prefix) if format.include? :png
      save_pdf if format.include? :pdf
    end
    
    # Saves the range of cards to PNG 
    #
    # @param range: the range of cards over which this will be rendered. See {file:API.md#label-Specifying+Ranges Specifying Ranges}
    # @param dir: the directory for the output to be sent to. Will be created if it doesn't exist
    # @param prefix: the prefix of the file name to be printed
    def save_png(range: :all, dir: "_output", prefix: 'card_')
      range = rangeify(range); dir = dirify(dir, allow_create: true)
      range.each { |i| @cards[i].save_png(i, dir, prefix) }
    end

  end
end