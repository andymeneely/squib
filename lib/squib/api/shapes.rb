require_relative '../args/box'
require_relative '../args/draw'
require_relative '../args/card_range'
require_relative '../args/transform'
require_relative '../args/coords'

module Squib
  class Deck

    # DSL method. See http://squib.readthedocs.io
    def rect(opts = {})
      range = Args::CardRange.new(opts[:range], deck_size: size)
      box   = Args::Box.new(self).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      draw  = Args::Draw.new(custom_colors).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      trans  = Args::Transform.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
      range.each { |i| @cards[i].rect(box[i], draw[i], trans[i]) }
    end

    # DSL method. See http://squib.readthedocs.io
    def circle(opts = {})
      range  = Args::CardRange.new(opts[:range], deck_size: size)
      coords = Args::Coords.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
      draw   = Args::Draw.new(custom_colors).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      range.each { |i| @cards[i].circle(coords[i], draw[i]) }
    end

    # DSL method. See http://squib.readthedocs.io
    def ellipse(opts = {})
      range = Args::CardRange.new(opts[:range], deck_size: size)
      draw  = Args::Draw.new(custom_colors).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      box   = Args::Box.new(self, { width: '0.25in', height: '0.25in' }).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      trans  = Args::Transform.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
      range.each { |i| @cards[i].ellipse(box[i], draw[i], trans[i]) }
    end

    # DSL method. See http://squib.readthedocs.io
    def grid(opts = {})
      range = Args::CardRange.new(opts[:range], deck_size: size)
      draw  = Args::Draw.new(custom_colors).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      box   = Args::Box.new(self).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      range.each { |i| @cards[i].grid(box[i], draw[i]) }
    end

    # DSL method. See http://squib.readthedocs.io
    def triangle(opts = {})
      range  = Args::CardRange.new(opts[:range], deck_size: size)
      draw   = Args::Draw.new(custom_colors).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      coords = Args::Coords.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
      range.each { |i| @cards[i].triangle(coords[i], draw[i]) }
    end

    # DSL method. See http://squib.readthedocs.io
    def line(opts = {})
      range   = Args::CardRange.new(opts[:range], deck_size: size)
      draw    = Args::Draw.new(custom_colors).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      coords  = Args::Coords.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
      range.each { |i| @cards[i].line(coords[i], draw[i]) }
    end

    # DSL method. See http://squib.readthedocs.io
    def curve(opts = {})
      range  = Args::CardRange.new(opts[:range], deck_size: size)
      draw   = Args::Draw.new(custom_colors).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      coords = Args::Coords.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
      range.each { |i| @cards[i].curve(coords[i], draw[i]) }
    end

    # DSL method. See http://squib.readthedocs.io
    def star(opts = {})
      range  = Args::CardRange.new(opts[:range], deck_size: size)
      draw   = Args::Draw.new(custom_colors).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      coords = Args::Coords.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
      trans  = Args::Transform.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
      range.each { |i| @cards[i].star(coords[i], trans[i], draw[i]) }
    end

    # DSL method. See http://squib.readthedocs.io
    def polygon(opts = {})
      range  = Args::CardRange.new(opts[:range], deck_size: size)
      draw   = Args::Draw.new(custom_colors).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      coords = Args::Coords.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
      trans  = Args::Transform.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
      range.each { |i| @cards[i].polygon(coords[i], trans[i], draw[i]) }
    end

    # DSL method. See http://squib.readthedocs.io
    def safe_zone(opts = {})
      safe_defaults = {
        margin: '0.25in',
        radius: '0.125in',
        stroke_color: :blue,
        fill_color: '#0000',
        stroke_width: 1.0,
        dash: '3 3',
      }
      new_opts = safe_defaults.merge(opts)
      margin = Args::UnitConversion.parse new_opts[:margin]
      new_opts[:x] = margin
      new_opts[:y] = margin
      new_opts[:width] = width - (2 * margin)
      new_opts[:height] = height - (2 * margin)
      rect new_opts
    end

    # DSL method. See http://squib.readthedocs.io
    def cut_zone(opts = {})
      safe_defaults = {
        margin: '0.125in',
        radius: '0.125in',
        stroke_color: :red,
        fill_color: '#0000',
        stroke_width: 2.0,
      }
      new_opts = safe_defaults.merge(opts)
      margin = Args::UnitConversion.parse new_opts[:margin]
      new_opts[:x] = margin
      new_opts[:y] = margin
      new_opts[:width] = width - (2 * margin)
      new_opts[:height] = height - (2 * margin)
      rect new_opts
    end

  end
end
