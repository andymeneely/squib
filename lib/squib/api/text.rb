module Squib
  class Deck
    def fontify (font)
      font = 'Arial 36' if font==:use_set
      font
    end

    def font(type: 'Arial', size: 12, **options)
      raise 'Not implemented!'
    end

    def set_font(type: 'Arial', size: 12, **options)
      raise 'Not implemented!'
    end

    def text(range: :all, str: '', font: :use_set, x: 0, y: 0, **options)
      range = rangeify(range)
      str = [str] * @cards.size unless str.respond_to? :each
      font = fontify(font)
      color = colorify(options[:color])
      range.each do |i|
        cards[i].text(str[i], font, x, y, color, options)
      end
    end

  end
end