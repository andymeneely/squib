module Squib
  class Deck

    def hint(text: nil)
      @text_hint = colorify(text, nillable: true)
    end

  end
end
