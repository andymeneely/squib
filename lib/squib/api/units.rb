require_relative '../constants'

module Squib
  class Deck

    # DSL method. See http://squib.readthedocs.io
    def inches(n)
      @dpi * n.to_f
    end

    # DSL method. See http://squib.readthedocs.io
    def cm(n)
      @dpi * Squib::INCHES_IN_CM * n.to_f
    end

  end
end
