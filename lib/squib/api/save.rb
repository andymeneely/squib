module Squib
  class Deck
  
    def save(range: :all, format: :png)
      format = [format].flatten
      save_png(range: range) if format.include? :png
      save_pdf if format.include? :pdf
    end
    
    def save_png(range: :all)
      range = rangeify(range)
      range.each { |i| @cards[i].save_png(i) }
    end

  end
end