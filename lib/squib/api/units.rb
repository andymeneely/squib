require_relative '../constants'

module Squib
  class Deck

    # DSL method. See http://squib.readthedocs.io
    def inches(n)
      @dpi * n.to_f
    end

    # DSL method. See http://squib.readthedocs.io
    def points(n)
      @dpi / Squib::POINTS_PER_IN * n.to_f
    end

    # DSL method. See http://squib.readthedocs.io
    def cm(n)
      @dpi * Squib::INCHES_IN_CM * n.to_f
    end

    # DSL method. See http://squib.readthedocs.io
    def mm(n)
      @dpi * Squib::INCHES_IN_CM * n.to_f / 10.0
    end

    # DSL method. See http://squib.readthedocs.io
    def cells(n)
      @cell_size * n.to_f
    end
    alias_method :cell, :cells

  end
end
