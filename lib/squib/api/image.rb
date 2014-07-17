module Squib
  class Deck
    
    def png(range=:all, file: nil, x: 0, y: 0)
      range = rangeify(range)
      file = fileify(file)
      range.each{ |i| @cards[i].png(file, x, y) }
    end

  end
end