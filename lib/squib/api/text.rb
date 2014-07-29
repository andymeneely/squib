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
    # @option opts range [Enumerable, :all] (:all) the range of cards over which this will be rendered. See {file:API.md#label-Specifying+Ranges Specifying Ranges}
    # @option opts str [String, Array] ('')  the string to be rendered. Must support `#to_s`. If the card responds to `#each`, it's mapped out one at a time across the cards.
    # @option opts font [String] (Arial 36 or whatever was set with `set`) the Font description string, including family, styles, and size.
    #   (e.g. `'Arial bold italic 12'`)
    #   For the official documentation, see the [Pango docs](http://ruby-gnome2.sourceforge.jp/hiki.cgi?Pango%3A%3AFontDescription#style). 
    #   This [description](http://www.pygtk.org/pygtk2reference/class-pangofontdescription.html) is also quite good.
    #   See the {file:samples/text-options.rb samples/text.rb} as well.
    # @option opts x [Integer] (0) the x-coordinate to place
    # @option opts y [Integer] (0) the y-coordinate to place
    # @option opts color [String] (:black) the color the font will render to. See {file:API.md#label-Specifying+Colors Specifying Colors}
    # @option opts markup: [Boolean] (false) Enable markup parsing of `str` using the HTML-like Pango Markup syntax, defined [here](http://ruby-gnome2.sourceforge.jp/hiki.cgi?pango-markup) and [here](https://developer.gnome.org/pango/stable/PangoMarkupFormat.html).
    # @option opts width [Integer, :native] (:native) the width of the box the string will be placed in. Stretches to the content by default.
    # @option opts height [Integer, :native] the height of the box the string will be placed in. Stretches to the content by default.
    # @option opts layout [String, Symbol] (nil) entry in the layout to use as defaults for this command. See {file:API.md#label-Custom+Layouts Custom Layouts}
    # @option opts wrap [:none, :word, :char, :word_char, true, false] (:word_char) When height is set, determines the behavior of how the string wraps. The `:word_char` option will break at words, but then fall back to characters when the word cannot fit.    #   
    #   Options are `:none, :word, :char, :word_char`. Also: `true` is the same as `:word_char`, `false` is the same as `:none`. Default `:word_char`
    # @option opts align [:left, right, :center] (:left) The alignment of the text
    # @option opts justify [Boolean] (false) toggles whether or not the text is justified or not. 
    # @option opts valign [:top, :middle, :bottom] (:top) When width and height are set, align text vertically according to the logical extents of the text.
    # @option opts ellipsize [:none, :start, :middle, :end, true, false] (:end) When width and height are set, determines the behavior of overflowing text. Also: `true` maps to `:end` and `false` maps to `:none`. Default `:end`
    # @option opts hint [String] (:nil) draw a rectangle around the text with the given color. Overrides global hints (see {Deck#hint}). 
    # @return [nil] Returns nothing
    # @api public
    def text(opts = {})
      opts = needs(opts, [:range, :str, :font, :x, :y, :width, :height, :text_color, :wrap,
                          :align, :justify, :valign, :ellipsize, :hint, :layout])
      opts[:str] = [opts[:str]] * @cards.size unless opts[:str].respond_to? :each
      opts[:range].each do |i|
        @cards[i].text(opts[:str][i], opts[:font], opts[:x], opts[:y], opts[:color], opts)
      end
    end

  end
end