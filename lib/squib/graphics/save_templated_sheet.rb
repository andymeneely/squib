module Squib
  module Graphics
    class SaveTemplatedSheet

      def initialize(deck)
        @deck = deck
      end

      def render_sheet(range, sheet, tmpl)
        cc = init_cc(sheet, tmpl)
        cc.scale(72.0 / @deck.dpi, 72.0 / @deck.dpi)  # make it like pixels
        card_set = tmpl.cards
        per_sheet = card_set.size

        track_progress(range, sheet) do |bar|
          range.each do |i|
            next_page_if_needed(cc, i, per_sheet)

            card = @deck.cards[i]
            x = Args::UnitConversion.parse(
              card_set[i % per_sheet]['x'], @deck.dpi)
            y = Args::UnitConversion.parse(
              card_set[i % per_sheet]['y'], @deck.dpi)
            cc.set_source(card.cairo_surface, x, y)
            cc.paint

            bar.increment
          end
        cc.target.finish
        end
      end

      private

      # Initialize the Cairo Context
      def init_cc(sheet, tmpl)
        ratio = 72.0 / @deck.dpi

        surface = Cairo::PDFSurface.new(
          sheet.full_filename,
          Args::UnitConversion.parse(tmpl.sheet_width, @deck.dpi) * ratio,
          Args::UnitConversion.parse(tmpl.sheet_height, @deck.dpi) * ratio)

        Cairo::Context.new(surface)
      end

      def next_page_if_needed(cc, i, per_sheet)
        if (i != 0) and (i % per_sheet == 0)
          cc.show_page
        end
      end

      def track_progress(range, sheet)
        msg = "Saving templated sheet to #{sheet.full_filename}"
        @deck.progress_bar.start(msg, range.size) { |bar| yield(bar) }
      end
    end
  end
end
