module Squib
  class Deck

    # @api private todo
    def font(type: 'Arial', size: 12, **options)
      raise 'Not implemented!'
    end

    # @api private todo
    def set_font(type: 'Arial', size: 12, **options)
      raise 'Not implemented!'
    end

    # Renders a string at a given location, width, alignment, font, etc.
    #   Unix-like newlines are interpreted even on Windows. 
    #
    # @example See the {file:samples/text-options.rb samples/text.rb} for a lengthy example.
    # 
    # @param range: the range of cards over which this will be rendered. See {file:API.md#label-Specifying+Ranges Specifying Ranges}
    # @param str: the string to be rendered. Must support `#to_s`. If the card responds to `#each`, it's mapped out one at a time across the cards.
    # @param font: the Font description string, including family, styles, and size.
    #   (e.g. `'Arial bold italic 12'`)
    #   For the official documentation, see the [Pango docs](http://ruby-gnome2.sourceforge.jp/hiki.cgi?Pango%3A%3AFontDescription#style). 
    #   This [description](http://www.pygtk.org/pygtk2reference/class-pangofontdescription.html) is also quite good.
    #   See the {file:samples/text-options.rb samples/text.rb} as well.
    # @param x: the x-coordinate to place
    # @param y: the y-coordinate to place
    # @param options: captures the additional input options below
    # @option color: (default: :black) the color the font will render to. See {file:API.md#label-Specifying+Colors Specifying Colors}
    # @option markup: [Boolean] (default: false) Enable markup parsing of `str` using the HTML-like Pango Markup syntax, defined [here](http://ruby-gnome2.sourceforge.jp/hiki.cgi?pango-markup) and [here](https://developer.gnome.org/pango/stable/PangoMarkupFormat.html).
    # @option width: the width of the box the string will be placed in. Stretches to the content by default.
    # @option height: the height of the box the string will be placed in. Stretches to the content by default.
    # @option wrap: When height is set, determines the behavior of how the string wraps. The `:word_char` option will break at words, but then fall back to characters when the word cannot fit.    #   
    #   Options are `:none, :word, :char, :word_char`. Also: `true` is the same as `:word_char`, `false` is the same as `:none`. Default `:word_char`
    # @option fitxy: sets the text `width` and `height` to be equal to `width - x` and `height - y` for easy centering
    # @option align: options `:left, :right, and :center`. Default `:left`
    # @option justify: [Boolean] toggles whether or not the text is justified or not. Default `false`
    # @option valign: When width and height are set, align text vertically according to the logical extents of the text. Options are `:top, :middle, :bottom`. Default `:top`
    # @option ellipsize: When width and height are set, determines the behavior of overflowing text. Options are `:none, :start, :middle, :end`. Also: `true` maps to `:end` and `false` maps to `:none`. Default `:end`
    # @option hint: show a text hint with the given color. Overrides global hints (see {Deck#hint}). 
    # @return [nil] Returns nothing
    # @api public
    def text(opts = {})
      opts = needs(opts, [:range, :str, :font, :x, :y, :width, :height, :color, :wrap, 
                          :fitxy, :align, :justify, :valign, :ellipsize, :hint])
      str = [opts[:str]] * @cards.size unless str.respond_to? :each
      opts[:range].each do |i|
        @cards[i].text(str[i], opts[:font], opts[:x], opts[:y], opts[:color], opts) #TODO split this out
      end
    end

  end
end