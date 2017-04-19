module Squib
  module Graphics
    class SaveTemplatedSheet

      def initialize(deck, tmpl)
        @deck = deck
        @tmpl = tmpl
        @rotated_delta = (@tmpl.card_width - @deck.width).abs / 2
      end

      def render_sheet(range, sheet)
        cc = init_cc(sheet)
        cc.scale(72.0 / @deck.dpi, 72.0 / @deck.dpi)  # make it like pixels
        card_set = @tmpl.cards
        per_sheet = card_set.size
        angle = detect_card_orientation

        if range.size
          draw_overlay_below_cards cc
        end

        track_progress(range, sheet) do |bar|
          range.each do |i|
            next_page_if_needed(cc, i, per_sheet)

            card = @deck.cards[i]
            x = card_set[i % per_sheet]['x']
            y = card_set[i % per_sheet]['y']

            if angle
              draw_rotated_card cc, card, x, y, angle
            else
              cc.set_source card.cairo_surface, x, y
            end
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

      def detect_card_orientation
        clockwise = 1.5 * Math::PI
        # Simple detection
        if (
            @deck.width == @tmpl.card_width and
            @deck.height == @tmpl.card_height)
          return false
        elsif (
            @deck.width == @tmpl.card_height and
            @deck.height == @tmpl.card_width)
          Squib::logger.warn {
            'Rotating cards to match templated file card orientation.' }
          return clockwise
        end

        # Edge case
        Squib::logger.warn {
          'Card dimensions of the deck does not match the template.' }
        is_tmpl_card_landscape = @tmpl.card_width > @tmpl.card_height
        is_deck_card_landscape = @deck.width > @deck.height
        if is_tmpl_card_landscape == is_deck_card_landscape
          clockwise
        else
          false
        end
      end

      def draw_rotated_card cc, card, x, y, angle
        # Normalize the angles first
        angle = angle % (2 * Math::PI)
        if angle < 0
          angle = 2 * Math::PI - angle
        end

        # Determine what's the delta we need to translate our cards
        delta_shift = (@deck.width < @deck.height)? 1: -1
        if angle == 0 or angle == Math::PI
          delta = 0
        elsif angle < Math::PI
          delta = -delta_shift * @rotated_delta
        else
          delta = delta_shift * @rotated_delta
        end

        # Perform the actual rotation and drawing
        mat = cc.matrix  # Save the transformation matrix to revert later
        cc.translate x, y
        cc.translate @deck.width/2, @deck.height/2
        cc.rotate angle
        cc.translate(-@deck.width/2 + delta, -@deck.height/2 + delta)
        cc.set_source card.cairo_surface, 0, 0
        cc.matrix = mat
      end
    end
  end
end
