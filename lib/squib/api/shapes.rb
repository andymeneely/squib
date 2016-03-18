require_relative '../args/box'
require_relative '../args/draw'
require_relative '../args/card_range'
require_relative '../args/transform'
require_relative '../args/coords'

module Squib
  class Deck

    # DSL method. See http://squib.readthedocs.org
    def rect(opts = {})
      range = Args::CardRange.new(opts[:range], deck_size: size)
      box   = Args::Box.new(self).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      draw  = Args::Draw.new(custom_colors).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      range.each { |i| @cards[i].rect(box[i], draw[i]) }
    end

    # DSL method. See http://squib.readthedocs.org
    def circle(opts = {})
      range  = Args::CardRange.new(opts[:range], deck_size: size)
      coords = Args::Coords.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
      draw   = Args::Draw.new(custom_colors).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      range.each { |i| @cards[i].circle(coords[i], draw[i]) }
    end

    # DSL method. See http://squib.readthedocs.org
    def ellipse(opts = {})
      range = Args::CardRange.new(opts[:range], deck_size: size)
      draw  = Args::Draw.new(custom_colors).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      box   = Args::Box.new(self, { width: '0.25in', height: '0.25in' }).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      range.each { |i| @cards[i].ellipse(box[i], draw[i]) }
    end

    # DSL method. See http://squib.readthedocs.org
    def grid(opts = {})
      range = Args::CardRange.new(opts[:range], deck_size: size)
      draw  = Args::Draw.new(custom_colors).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      box   = Args::Box.new(self).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      range.each { |i| @cards[i].grid(box[i], draw[i]) }
    end

    # DSL method. See http://squib.readthedocs.org
    def triangle(opts = {})
      range  = Args::CardRange.new(opts[:range], deck_size: size)
      draw   = Args::Draw.new(custom_colors).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      coords = Args::Coords.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
      range.each { |i| @cards[i].triangle(coords[i], draw[i]) }
    end

    # DSL method. See http://squib.readthedocs.org
    def line(opts = {})
      range   = Args::CardRange.new(opts[:range], deck_size: size)
      draw    = Args::Draw.new(custom_colors).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      coords  = Args::Coords.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
      range.each { |i| @cards[i].line(coords[i], draw[i]) }
    end

    # DSL method. See http://squib.readthedocs.org
    def curve(opts = {})
      range  = Args::CardRange.new(opts[:range], deck_size: size)
      draw   = Args::Draw.new(custom_colors).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      coords = Args::Coords.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
      range.each { |i| @cards[i].curve(coords[i], draw[i]) }
    end

    # DSL method. See http://squib.readthedocs.org
    def star(opts = {})
      range  = Args::CardRange.new(opts[:range], deck_size: size)
      draw   = Args::Draw.new(custom_colors).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      coords = Args::Coords.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
      trans  = Args::Transform.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
      range.each { |i| @cards[i].star(coords[i], trans[i], draw[i]) }
    end

    # DSL method. See http://squib.readthedocs.org
    def polygon(opts = {})
      range  = Args::CardRange.new(opts[:range], deck_size: size)
      draw   = Args::Draw.new(custom_colors).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      coords = Args::Coords.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
      trans  = Args::Transform.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
      range.each { |i| @cards[i].polygon(coords[i], trans[i], draw[i]) }
    end

  end
end
