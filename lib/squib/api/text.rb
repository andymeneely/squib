module Squib
  class Deck
    def font(type: 'Arial', size: 12, **options)
      raise 'Not implemented!'
    end

    def set_font(type: 'Arial', size: 12, **options)
      raise 'Not implemented!'
    end

    #
    # font: description string, including family, styles, and size.
    # 
    # => e.g. 'Arial bold italic 12'
    # For the official documentation the string, see the [Pango docs](http://ruby-gnome2.sourceforge.jp/hiki.cgi?Pango%3A%3AFontDescription#style). 
    # This [description](http://www.pygtk.org/pygtk2reference/class-pangofontdescription.html) is also quite good.
    def text(range: :all, str: '', font: :use_set, x: 0, y: 0, **options)
      range = rangeify(range)
      str = [str] * @cards.size unless str.respond_to? :each
      font = fontify(font)
      color = colorify(options[:color], nillable: false)
      options['hint'] = colorify(options['hint']) unless options['hint'].nil?
      range.each do |i|
        cards[i].text(str[i], font, x, y, color, options)
      end
    end

  end
end