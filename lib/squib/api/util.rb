# Externally visible utility functions
module Squib
  class Deck

    def allSatisfying(data)
      data.each_index.select{ |i| yield(data[i]) }
    end

    def allBetweenTypes(data, from, to)
     id = {} ; data.each_with_index{ |name,i| id[name] = i}
     id[from]..id[to]
    end

    def allOfType(data, type)
      allSatisfying(data) { |v| v == type }
    end

    def allExceptType(data, type)
      allSatisfying(data) { |v| v != type }
    end

  end
end
