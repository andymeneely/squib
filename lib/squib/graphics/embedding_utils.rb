module Squib
  class EmbeddingUtils

    # Given a string and a bunch of keys, give us back a mapping of those keys
    # to where those keys start, and where they end (in ranges)
    #
    # See the spec for expected outputs
    def self.indices(str, keys)
      map = {}
      keys.each do |key|
        map[key] ||= []
        start = 0
        while true
          idx = str.index(key, start)
          if idx.nil?
            break; # done searching
          else
            idx_bytes = str[0..idx].bytesize - 1
            map[key] << (idx_bytes..(idx_bytes + key.size))
            start = idx + 1
          end
        end
      end
      return map
    end

  end
end
