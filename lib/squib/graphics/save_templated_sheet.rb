module Squib
  module Graphics
    class SaveTemplatedSheet

      def initialize(deck, tmpl)
        @deck = deck
        @tmpl = tmpl
      end

      def render_sheet(range, sheet)
        cc = init_cc(sheet)
        cc.scale(72.0 / @deck.dpi, 72.0 / @deck.dpi)  # make it like pixels
        card_set = @tmpl.cards
        per_sheet = card_set.size

        if range.size
          draw_overlay_below_cards cc
        end

        track_progress(range, sheet) do |bar|
          range.each do |i|
            next_page_if_needed(cc, i, per_sheet)

            card = @deck.cards[i]
            x = card_set[i % per_sheet]['x']
            y = card_set[i % per_sheet]['y']
            cc.set_source(card.cairo_surface, x, y)
            cc.paint

            bar.increment
          end

        draw_overlay_above_cards cc
        cc.target.finish
        end
      end

      private

      # Initialize the Cairo Context
      def init_cc(sheet)
        ratio = 72.0 / @deck.dpi

        surface = Cairo::PDFSurface.new(
          sheet.full_filename,
          @tmpl.sheet_width * ratio,
          @tmpl.sheet_height * ratio)

        Cairo::Context.new(surface)
      end

      def next_page_if_needed(cc, i, per_sheet)
        if (i != 0) and (i % per_sheet == 0)
          draw_overlay_above_cards cc
          cc.show_page
          draw_overlay_below_cards cc
        end
      end

      def track_progress(range, sheet)
        msg = "Saving templated sheet to #{sheet.full_filename}"
        @deck.progress_bar.start(msg, range.size) { |bar| yield(bar) }
      end

      def draw_overlay_below_cards(cc)
        if @tmpl.crop_line_overlay == :on_margin
          set_margin_overlay_clip_mask cc
          cc.clip
          draw_crop_line cc
          cc.reset_clip
        else @tmpl.crop_line_overlay == :beneath_cards
          draw_crop_line cc
        end
      end

      def draw_overlay_above_cards(cc)
        if @tmpl.crop_line_overlay == :overlay_on_cards
          draw_crop_line cc
        end
      end

      def set_margin_overlay_clip_mask(cc)
        margin = @tmpl.margin
        cc.new_path
        cc.rectangle(
          margin[:left], margin[:top],
          margin[:right] - margin[:left],
          margin[:bottom] - margin[:top])
        cc.new_sub_path
        cc.move_to @tmpl.sheet_width, 0
        cc.line_to 0, 0
        cc.line_to 0, @tmpl.sheet_height
        cc.line_to @tmpl.sheet_width, @tmpl.sheet_height
        cc.close_path
      end

      def draw_crop_line(cc)
        @tmpl.crop_lines { |line|
          cc.move_to line['line'].x1, line['line'].y1
          cc.line_to line['line'].x2, line['line'].y2
          cc.set_source_color line['color']
          cc.set_line_width line['width']
          if line['style'].pattern
            cc.set_dash(line['style'].pattern)
          end
          cc.stroke
        }
      end
    end
  end
end
