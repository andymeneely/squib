require 'squib/constants'
module Squib
  module Args
    class Typographer

      def initialize(config = Conf::DEFAULTS)
      %w(lsquote ldquote rsquote rdquote smart_quotes
         em_dash en_dash ellipsis).each do |var|
          instance_variable_set("@#{var}", config[var])
        end
      end

      def process(str)
        str = explicit_replacements(str.to_s)
        str = smart_quotes(str) if @smart_quotes
        str
      end

      def explicit_replacements(str)
        [ :left_curly, :right_curly, :apostraphize,
          :ellipsificate, :em_dash, :en_dash ].each do |sym|
          str = each_non_tag(str) do |token|
            self.method(sym).call(token)
          end
        end
        str
      end

      def smart_quotes(str)
        [ :single_inside_double_quote,
          :right_double_quote,
          :left_double_quote,
          :right_single_quote,
          :left_single_quote].each do |sym|
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
        str.gsub('``', @ldquote)
      end

      # Straightforward replace
      def right_curly(str)
        str.gsub(%{''}, @rdquote)
      end

      # A quote between two letters is an apostraphe
      def apostraphize(str)
        str.gsub(/(\w)(\')(\w)/, '\1' + @rsquote + '\3')
      end

      # Straightforward replace
      def ellipsificate(str)
        str.gsub('...', @ellipsis)
      end

      # Straightforward replace
      def en_dash(str)
        str.gsub('--', @en_dash)
      end

      # Straightforward replace
      def em_dash(str)
        str.gsub('---', @em_dash)
      end

      # Quote next to non-whitespace curls
      def right_double_quote(str)
        str.gsub(/(\S)(\")/, '\1' + @rdquote)
      end

      # Quote next to non-whitespace curls
      def left_double_quote(str)
        str.gsub(/(\")(\S)/, @ldquote + '\2')
      end

      # Handle the cases where a double quote is next to a single quote
      def single_inside_double_quote(str)
        str.gsub(/(\")(\')(\S)/, @ldquote + @lsquote + '\3')
           .gsub(/(\")(\')(\S)/, '\1' + @rsquote + @rdquote)
      end

      # Quote next to non-whitespace curls
      def right_single_quote(str)
        str.gsub(/(\S)(\')/, '\1' + @rsquote)
      end

      # Quote next to non-whitespace curls
      def left_single_quote(str)
        str.gsub(/(\')(\S)/, @lsquote + '\2')
      end

    end
  end
end