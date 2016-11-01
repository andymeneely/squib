require_relative '../args/card_range'
require_relative '../args/hand_special'
require_relative '../args/save_batch'
require_relative '../args/sheet'
require_relative '../args/showcase_special'
require_relative '../graphics/save_pdf'

module Squib
  class Deck

    # DSL method. See http://squib.readthedocs.io
    def save(opts = {})
      save_png(opts) if Array(opts[:format]).include? :png
      save_pdf(opts) if Array(opts[:format]).include? :pdf
      self
    end

    # DSL method. See http://squib.readthedocs.io
    def save_pdf(opts = {})
      range = Args::CardRange.new(opts[:range], deck_size: size)
      sheet = Args::Sheet.new(custom_colors, { file: 'output.pdf' }).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      Graphics::SavePDF.new(self).render_pdf(range, sheet)
    end

    # DSL method. See http://squib.readthedocs.io
    def save_png(opts = {})
      range = Args::CardRange.new(opts[:range], deck_size: size)
      batch = Args::SaveBatch.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
      @progress_bar.start("Saving PNGs to #{batch.summary}", size) do |bar|
        range.each do |i|
          @cards[i].save_png(batch[i])
          bar.increment
        end
      end
    end

    # DSL method. See http://squib.readthedocs.io
    def save_sheet(opts = {})
      range = Args::CardRange.new(opts[:range], deck_size: size)
      batch = Args::SaveBatch.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
      sheet = Args::Sheet.new(custom_colors, { margin: 0 }, size).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      render_sheet(range, batch, sheet)
    end

    # DSL method. See http://squib.readthedocs.io
    def showcase(opts = {})
      range    = Args::CardRange.new(opts[:range], deck_size: size)
      showcase = Args::ShowcaseSpecial.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
      sheet    = Args::Sheet.new(custom_colors, { file: 'showcase.png' }).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      render_showcase(range, sheet, showcase)
    end

    # DSL method. See http://squib.readthedocs.io
    def hand(opts = {})
      range = Args::CardRange.new(opts[:range], deck_size: size)
      hand  = Args::HandSpecial.new(height).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      sheet = Args::Sheet.new(custom_colors, { file: 'hand.png', trim_radius: 0 }).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      render_hand(range, sheet, hand)
    end

  end
end
