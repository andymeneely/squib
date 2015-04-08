require 'squib/constants'
module Squib
  module Args
    class Typographer

      def initialize(config = CONFIG_DEFAULTS)
        @config = config
      end

      def process(str)
        str = explicit_replacements(str)
        str = smart_quotes(str) if @config['smart_quotes']
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
        str.gsub('``', @config['ldquote'])
      end

      # Straightforward replace
      def right_curly(str)
        str.gsub(%{''}, @config['rdquote'])
      end

      # A quote between two letters is an apostraphe
      def apostraphize(str)
        str.gsub(/(\w)(\')(\w)/, '\1' + @config['rsquote'] + '\3')
      end

      # Straightforward replace
      def ellipsificate(str)
        str.gsub('...', @config['ellipsis'])
      end

      # Straightforward replace
      def en_dash(str)
        str.gsub('--', @config['en_dash'])
      end

      # Straightforward replace
      def em_dash(str)
        str.gsub('---', @config['em_dash'])
      end

      # Quote next to non-whitespace curls
      def right_double_quote(str)
        str.gsub(/(\S)(\")/, '\1' + @config['rdquote'])
      end

      # Quote next to non-whitespace curls
      def left_double_quote(str)
        str.gsub(/(\")(\S)/, @config['ldquote'] + '\2')
      end

      # Handle the cases where a double quote is next to a single quote
      def single_inside_double_quote(str)
        str.gsub(/(\")(\')(\S)/, @config['ldquote'] + @config['lsquote'] + '\3')
           .gsub(/(\")(\')(\S)/, '\1' + @config['rsquote'] + @config['rdquote'])
      end

      # Quote next to non-whitespace curls
      def right_single_quote(str)
        str.gsub(/(\S)(\')/, '\1' + @config['rsquote'])
      end

      # Quote next to non-whitespace curls
      def left_single_quote(str)
        str.gsub(/(\')(\S)/, @config['lsquote'] + '\2')
      end

    end
  end
end