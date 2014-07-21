module Squib
  class Deck

    # Toggle hints globally. 
    #   Text hints are rectangles around where the text will be laid out. They are intended to be temporary.
    #   Setting a hint to nil or to :off will disable hints. @see samples/text.rb
    #
    # @param [Color] text the color of the text hint. To turn off use nil or :off. @see API.md 
    # @return nil
    # @api public
    def hint(text: nil)
      text = nil if text == :off
      @text_hint = colorify(text, nillable: true)
    end

  end
end
