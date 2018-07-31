module Squib
  module Graphics
    # Helper class to generate templated sheet.
    class SaveSprue
      def initialize(deck, tmpl, sheet_args)
        @deck = deck
        @tmpl = tmpl
        @page_number = 1
        @sheet_args = sheet_args # might be Args::Sheet or Args::SaveBatch
        @overlay_lines = @tmpl.crop_lines.select do |line|
          line['overlay_on_cards']
        end
      end

      def render_sheet(range)
        cc = init_cc
        cc.set_source_color(:white) # white backdrop TODO make option
        cc.paint
        slots = @tmpl.cards
        per_sheet = slots.size
        check_oversized_card

        draw_overlay_below_cards cc if range.size

        track_progress(range) do |bar|
          range.each do |i|
            cc = next_page_if_needed(cc, i, per_sheet)

            card = @deck.cards[i]
            slot = slots[i % per_sheet]

            draw_card cc, card,
                      slot['x'], slot['y'],
                      slot['rotate'],
                      @sheet_args.trim, @sheet_args.trim_radius

            bar.increment
          end

          draw_overlay_above_cards cc
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
        return cc unless (i != 0) && (i % per_sheet) == 0

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

      def check_oversized_card
        Squib.logger.warn {
          "Card size is larger than sprue's expected card size "\
          "of #{@tmpl.card_width}x#{@tmpl.card_height}. Cards may overlap."
        } if (@deck.width - 2.0 * @sheet_args.trim)  > @tmpl.card_width ||
             (@deck.height - 2.0 * @sheet_args.trim) > @tmpl.card_height
      end

      def draw_card(cc, card, x, y, angle, trim, trim_radius)
        # Compute the true size of the card after trimming
        w = @deck.width - 2.0 * trim
        h = @deck.height - 2.0 * trim

        # Normalize the angles first
        # TODO do this in the args class
        angle = angle % (2 * Math::PI)
        angle = 2 * Math::PI - angle if angle < 0

        # Perform the actual rotation and drawing
        mat = cc.matrix # Save the transformation matrix to revert later
        cc.translate x, y
        cc.translate @deck.width / 2.0, @deck.height / 2.0
        cc.rotate angle
        cc.translate -@deck.width / 2.0, -@deck.height / 2.0
        cc.rounded_rectangle(trim, trim, w, h, trim_radius, trim_radius) # clip
        cc.clip
        cc.set_source card.cairo_surface, 0, 0
        cc.matrix = mat
        cc.paint
        cc.reset_clip
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
        @sheet_args.full_filename
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
        @sheet_args.full_filename @page_number
      end
    end
  end
end
