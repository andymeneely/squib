module Squib
  class Deck
  
    def save(range: :all, dir: "_output", format: :png, prefix: "card_")
      format = [format].flatten
      save_png(range: range, dir: dir, prefix: prefix) if format.include? :png
      save_pdf if format.include? :pdf
    end
    
    def save_png(range: :all, dir: "_output", prefix: 'card_')
      range = rangeify(range); dir = dirify(dir, allow_create: true)
      range.each { |i| @cards[i].save_png(i, dir, prefix) }
    end

  end
end