module Squib
  module Graphics
    # Helper class to generate templated sheet.
    class SaveSprue
      def initialize(deck, tmpl, outfile)
        @deck = deck
        @tmpl = tmpl
        @page_number = 1
        @outfile = outfile
        @rotated_delta = (@tmpl.card_width - @deck.width).abs / 2
        @overlay_lines = @tmpl.crop_lines.select do |line|
          line['overlay_on_cards']
        end
      end

      def render_sheet(range)
        cc = init_cc
        cc.set_source_color(:white) # white backdrop TODO make option
        cc.paint
        card_set = @tmpl.cards
        per_sheet = card_set.size
        default_angle = @tmpl.card_default_rotation
        if default_angle.zero?
          default_angle = check_card_orientation
        end

        draw_overlay_below_cards cc if range.size

        track_progress(range) do |bar|
          range.each do |i|
            cc = next_page_if_needed(cc, i, per_sheet)

            card = @deck.cards[i]
            slot = card_set[i % per_sheet]
            x = slot['x']
            y = slot['y']
            angle = slot['rotate'] != 0 ? slot['rotate'] : default_angle

            if angle != 0
              draw_rotated_card cc, card, x, y, angle
            else
              cc.set_source card.cairo_surface, x, y
            end
            cc.paint

            bar.increment
          end

          draw_overlay_above_cards cc
          cc = draw_page cc
          cc.target.finish
        end
      end

      protected

      # Initialize the Cairo Context
      def init_cc
        raise NotImplementedError
      end

      def draw_page(cc)
        raise NotImplementedError
      end

      def full_filename
        raise NotImplementedError
      end

      private

      def next_page_if_needed(cc, i, per_sheet)
        return cc unless (i != 0) && (i % per_sheet).zero?

        draw_overlay_above_cards cc
        cc = draw_page cc
        draw_overlay_below_cards cc
        @page_number += 1
        cc
      end

      def track_progress(range)
        msg = "Saving templated sheet to #{full_filename}"
        @deck.progress_bar.start(msg, range.size) { |bar| yield(bar) }
      end

      def draw_overlay_below_cards(cc)
        if @tmpl.crop_line_overlay == :on_margin
          add_margin_overlay_clip_mask cc
          cc.clip
          draw_crop_line cc, @tmpl.crop_lines
          cc.reset_clip
        elsif @tmpl.crop_line_overlay == :beneath_cards
          draw_crop_line cc, @tmpl.crop_lines
        end
      end

      def draw_overlay_above_cards(cc)
        if @tmpl.crop_line_overlay == :overlay_on_cards
          draw_crop_line cc, @tmpl.crop_lines
        else
          draw_crop_line cc, @overlay_lines
        end
      end

      def add_margin_overlay_clip_mask(cc)
        margin = @tmpl.margin
        cc.new_path
        cc.rectangle(
          margin[:left], margin[:top],
          margin[:right] - margin[:left],
          margin[:bottom] - margin[:top]
        )
        cc.new_sub_path
        cc.move_to @tmpl.sheet_width, 0
        cc.line_to 0, 0
        cc.line_to 0, @tmpl.sheet_height
        cc.line_to @tmpl.sheet_width, @tmpl.sheet_height
        cc.close_path
      end

      def draw_crop_line(cc, crop_lines)
        crop_lines.each do |line|
          cc.move_to line['line'].x1, line['line'].y1
          cc.line_to line['line'].x2, line['line'].y2
          cc.set_source_color line['color']
          cc.set_line_width line['width']
          cc.set_dash(line['style'].pattern) if line['style'].pattern
          cc.stroke
        end
      end

      def check_card_orientation
        clockwise = 1.5 * Math::PI
        if @deck.width <= @tmpl.card_width &&
           @deck.height <= @tmpl.card_height
          return 0
        elsif (
            @deck.width == @tmpl.card_height &&
            @deck.height == @tmpl.card_width)
          Squib.logger.warn {
            'Rotating cards to match card orientation in template.'
          }
          return clockwise
        end

        Squib.logger.warn {
          'Card size is larger than sprue\'s expected card size. '\
          'Cards may overlap.'
        }
        return 0
      end

      def draw_rotated_card(cc, card, x, y, angle)
        # Normalize the angles first
        angle = angle % (2 * Math::PI)
        angle = 2 * Math::PI - angle if angle < 0

        # Determine what's the delta we need to translate our cards
        delta_shift = @deck.width < @deck.height ? 1 : -1
        if angle.zero? || angle == Math::PI
          delta = 0
        elsif angle < Math::PI
          delta = -delta_shift * @rotated_delta
        else
          delta = delta_shift * @rotated_delta
        end

        # Perform the actual rotation and drawing
        mat = cc.matrix # Save the transformation matrix to revert later
        cc.translate x, y
        cc.translate @deck.width / 2, @deck.height / 2
        cc.rotate angle
        cc.translate(-@deck.width / 2 + delta, -@deck.height / 2 + delta)
        cc.set_source card.cairo_surface, 0, 0
        cc.matrix = mat
      end
    end

    # Templated sheet renderer in PDF format.
    class SaveSpruePDF < SaveSprue
      def init_cc
        ratio = 72.0 / @deck.dpi

        surface = Cairo::PDFSurface.new(
          full_filename,
          @tmpl.sheet_width * ratio,
          @tmpl.sheet_height * ratio
        )

        cc = Cairo::Context.new(surface)
        cc.scale(72.0 / @deck.dpi, 72.0 / @deck.dpi) # make it like pixels
        cc
      end

      def draw_page(cc)
        cc.show_page
        cc.set_source_color(:white) # white backdrop TODO make option
        cc.paint
        cc
      end

      def full_filename
        @outfile.full_filename
      end
    end

    # Templated sheet renderer in PNG format.
    class SaveSpruePNG < SaveSprue
      def init_cc
        surface = Cairo::ImageSurface.new @tmpl.sheet_width, @tmpl.sheet_height
        Cairo::Context.new(surface)
      end

      def draw_page(cc)
        cc.target.write_to_png(full_filename)
        init_cc
        cc.set_source_color(:white) # white backdrop TODO make option
        cc.paint
        cc
      end

      def full_filename
        @outfile.full_filename @page_number
      end
    end
  end
end
