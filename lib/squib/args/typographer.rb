require 'squib/constants'
module Squib
  module Args
    class Typographer

      def initialize(config = CONFIG_DEFAULTS)
        @config = config
      end

      def process(str)
        [
          :left_curly,
          :right_curly,
          :apostraphize,
          :right_double_quote,
          :left_double_quote,
          :right_single_quote,
          :left_single_quote,
          :ellipsificate,
          :em_dash,
          :en_dash ].each do |sym|
          str = each_non_tag(str) do |token|
            self.method(sym).call(token)
          end
        end
        str
      end

      # Iterate over each non-tag for processing
      # Allows us to ignore anything inside < and >
      def each_non_tag(str)
        full_str = ''
        tag_delimit = /(<(?:(?!<).)*>)/ # use non-capturing group w/ negative lookahead
        str.split(tag_delimit).each do |token|
          if token.start_with? '<'
            full_str << token # don't process tags
          else
            full_str << yield(token)
          end
        end
        return full_str
      end

      # Straightforward replace
      def left_curly(str)
        str.gsub('``', "\u201C")
      end

      # Straightforward replace
      def right_curly(str)
        str.gsub(%{''}, "\u201D")
      end

      # A quote between two letters is an apostraphe
      def apostraphize(str)
        str.gsub(/(\w)(\')(\w)/, '\1' + "\u2019" + '\3')
      end

      # Quote next to non-whitespace curls
      def right_double_quote(str)
        str.gsub(/(\S)(\")/, '\1' + "\u201D")
      end

      # Quote next to non-whitespace curls
      def left_double_quote(str)
        str.gsub(/(\")(\S)/, "\u201C" + '\2')
      end

      # Quote next to non-whitespace curls
      def right_single_quote(str)
        str.gsub(/(\S)(\')/, '\1' + "\u2019")
      end

      # Quote next to non-whitespace curls
      def left_single_quote(str)
        str.gsub(/(\')(\S)/, "\u2018" + '\2')
      end

      # Straightforward replace
      def ellipsificate(str)
        str.gsub('...', "\u2026")
      end

      # Straightforward replace
      def en_dash(str)
        str.gsub('--', "\u2013")
      end

      # Straightforward replace
      def em_dash(str)
        str.gsub('---', "\u2014")
      end

    end
  end
end