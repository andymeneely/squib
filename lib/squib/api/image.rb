require_relative '../args/card_range'
require_relative '../args/paint'
require_relative '../args/scale_box'
require_relative '../args/transform'
require_relative '../args/input_file'
require_relative '../args/svg_special'

module Squib
  class Deck

    # DSL method. See http://squib.readthedocs.io
    def png(opts = {})
      Dir.chdir(img_dir) do
        range = Args::CardRange.new(opts[:range], deck_size: size)
        paint = Args::Paint.new(custom_colors).load!(opts, expand_by: size, layout: layout)
        box   = Args::ScaleBox.new(self).load!(opts, expand_by: size, layout: layout, dpi: dpi)
        trans = Args::Transform.new(self).load!(opts, expand_by: size, layout: layout, dpi: dpi)
        ifile = Args::InputFile.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
        @progress_bar.start('Loading PNG(s)', range.size) do |bar|
          range.each do |i|
            @cards[i].png(ifile[i].file, box[i], paint[i], trans[i])
            bar.increment
          end
        end
      end
    end

    # DSL method. See http://squib.readthedocs.io
    def svg(opts = {})
      Dir.chdir(img_dir) do
        range = Args::CardRange.new(opts[:range], deck_size: size)
        paint = Args::Paint.new(custom_colors).load!(opts, expand_by: size, layout: layout)
        box   = Args::ScaleBox.new(self).load!(opts, expand_by: size, layout: layout, dpi: dpi)
        trans = Args::Transform.new(self).load!(opts, expand_by: size, layout: layout, dpi: dpi)
        ifile = Args::InputFile.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
        svg_args = Args::SvgSpecial.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
        @progress_bar.start('Loading SVG(s)', range.size) do |bar|
          range.each do |i|
            if svg_args.render?(i)
              @cards[i].svg(ifile[i].file, svg_args[i], box[i], paint[i], trans[i])
            end
            bar.increment
          end
        end
      end
    end

  end
end
