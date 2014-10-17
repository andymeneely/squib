module Squib
  class Deck

    # Renders a string at a given location, width, alignment, font, etc.
    #
    #   Unix-like newlines are interpreted even on Windows. 
    #   See the {file:samples/text-options.rb samples/text.rb} for a lengthy example.
    #
    # @example 
    #   text str: 'hello'
    #   text str: 'hello', x: 50, y:50, align: center
    # 
    # Options support Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    #
    # @option opts range [Enumerable, :all] (:all) the range of cards over which this will be rendered. See {file:README.md#Specifying_Ranges Specifying Ranges}
    # @option opts str [String, Array] ('')  the string to be rendered. Must support `#to_s`. If the card responds to `#each`, it's mapped out one at a time across the cards.
    # @option opts font [String] (Arial 36 or whatever was set with `set`) the Font description string, including family, styles, and size.
    #   (e.g. `'Arial bold italic 12'`)
    #   For the official documentation, see the [Pango docs](http://ruby-gnome2.sourceforge.jp/hiki.cgi?Pango%3A%3AFontDescription#style). 
    #   This [description](http://www.pygtk.org/pygtk2reference/class-pangofontdescription.html) is also quite good.
    #   See the {file:samples/text-options.rb samples/text.rb} as well.
    # @option opts font_size [Integer] (nil) an override of font string description, for scaling the font according to the size of the string
    # @option opts x [Integer] (0) the x-coordinate to place
    # @option opts y [Integer] (0) the y-coordinate to place
    # @option opts color [String] (:black) the color the font will render to. See {file:README.md#Specifying_Colors Specifying Colors}
    # @option opts markup: [Boolean] (false) Enable markup parsing of `str` using the HTML-like Pango Markup syntax, defined [here](http://ruby-gnome2.sourceforge.jp/hiki.cgi?pango-markup) and [here](https://developer.gnome.org/pango/stable/PangoMarkupFormat.html).
    # @option opts width [Integer, :native] (:native) the width of the box the string will be placed in. Stretches to the content by default.
    # @option opts height [Integer, :native] the height of the box the string will be placed in. Stretches to the content by default.
    # @option opts layout [String, Symbol] (nil) entry in the layout to use as defaults for this command. See {file:README.md#Custom_Layouts Custom Layouts}
    # @option opts wrap [:none, :word, :char, :word_char, true, false] (:word_char) When height is set, determines the behavior of how the string wraps. The `:word_char` option will break at words, but then fall back to characters when the word cannot fit.    #   
    #   Options are `:none, :word, :char, :word_char`. Also: `true` is the same as `:word_char`, `false` is the same as `:none`. Default `:word_char`
    # @option opts spacing [Integer] (0) Adjust the spacing when the text is multiple lines. No effect when the text does not wrap.
    # @option opts align [:left, right, :center] (:left) The alignment of the text
    # @option opts justify [Boolean] (false) toggles whether or not the text is justified or not. 
    # @option opts valign [:top, :middle, :bottom] (:top) When width and height are set, align text vertically according to the ink extents of the text.
    # @option opts ellipsize [:none, :start, :middle, :end, true, false] (:end) When width and height are set, determines the behavior of overflowing text. Also: `true` maps to `:end` and `false` maps to `:none`. Default `:end`
    # @option opts angle [FixNum] (0) Rotation of the text in radians. 
    # @option opts hint [String] (:nil) draw a rectangle around the text with the given color. Overrides global hints (see {Deck#hint}). 
    # @return [nil] Returns nothing
    # @api public
    def text(opts = {})
      opts = needs(opts, [:range, :str, :font, :font_size, :x, :y, :width, :height, :color, :wrap,
                          :align, :justify, :spacing, :valign, :markup, :ellipsize, :hint, :layout, :angle])
      opts[:range].each do |i|
        @cards[i].text(opts[:str][i], opts[:font][i], opts[:font_size][i], opts[:color][i],
                       opts[:x][i], opts[:y][i], opts[:width][i], opts[:height][i],
                       opts[:markup][i], opts[:justify][i], opts[:wrap][i], 
                       opts[:ellipsize][i], opts[:spacing][i], opts[:align][i], 
                       opts[:valign][i], opts[:hint][i], opts[:angle][i])
      end
    end

  end
end