module Squib
  class Deck
    
    def png(range: :all, file: nil, x: 0, y: 0)
      range = rangeify(range)
      file = fileify(file)
      range.each{ |i| @cards[i].png(file, x, y) }
    end

    def svg(range: :all, file: nil, x: 0, y: 0)
      range = rangeify(range)
      file = fileify(file)
      range.each{ |i| @cards[i].svg(file, x, y) }
    end

  end
end