module Squib
  module Args
    class SmartQuotes

      def process(str, opt)
        clean_opt = opt.to_s.downcase.strip
        return str if clean_opt.eql? 'dumb'
        if clean_opt.eql? 'smart'
          quotify(str) # default to UTF-8
        else
          quotify(str, opt) # supplied quotes
        end
      end

      # Convert regular quotes to smart quotes by looking for
      # a boundary between a word character (letters, numbers, underscore)
      # and a quote. Replaces with the UTF-8 equivalent.
      # :nodoc:
      # @api private
      def quotify(str, quote_chars = ["\u201C", "\u201D"])
        left_regex  = /(\")(\w)/
        right_regex = /(\w)(\")/
        str.gsub(left_regex,  quote_chars[0] + '\2')
           .gsub(right_regex, '\1' + quote_chars[1])
      end

    end
  end
end