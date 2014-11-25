require 'pango'

module Squib
  class Card

    # :nodoc:
    # @api private
    def draw_text_hint(cc,x,y,layout, color,angle)
      color = @deck.text_hint if color.to_s.eql? 'off' and not @deck.text_hint.to_s.eql? 'off'
      return if color.to_s.eql? 'off' or color.nil?
      # when w,h < 0, it was never set. extents[1] are ink extents
      w = layout.width / Pango::SCALE
      w = layout.extents[1].width / Pango::SCALE if w < 0
      h = layout.height / Pango::SCALE
      h = layout.extents[1].height / Pango::SCALE if h < 0
      cc.rounded_rectangle(x,y,w,h,0,0)
      cc.set_source_color(color)
      cc.set_line_width(2.0)
      cc.stroke
    end

    # :nodoc:
    # @api private
    def set_ellipsize!(layout, ellipsize)
      case ellipsize.to_s.downcase
      when 'none', 'false'
        layout.ellipsize = Pango::Layout::ELLIPSIZE_NONE
      when 'start'
        layout.ellipsize = Pango::Layout::ELLIPSIZE_START
      when 'middle'
        layout.ellipsize = Pango::Layout::ELLIPSIZE_MIDDLE
      when 'end', 'true'
        layout.ellipsize = Pango::Layout::ELLIPSIZE_END
      end
    end

    # :nodoc:
    # @api private
    def set_wrap!(layout, wrap)
      case wrap.to_s.downcase
      when 'word'
        layout.wrap = Pango::Layout::WRAP_WORD
      when 'char'
        layout.wrap = Pango::Layout::WRAP_CHAR
      when 'word_char', 'true'
        layout.wrap = Pango::Layout::WRAP_WORD_CHAR
      end
    end

    # :nodoc:
    # @api private
    def set_align!(layout, align)
      case align.to_s.downcase
      when 'left'
        layout.alignment = Pango::ALIGN_LEFT
      when 'right'
        layout.alignment = Pango::ALIGN_RIGHT
      when 'center'
        layout.alignment = Pango::ALIGN_CENTER
      end
    end

    # :nodoc:
    # @api private
    def valign!(cc, layout, x, y, valign)
      if layout.height > 0
        ink_extents = layout.extents[1]
        case valign.to_s
        when 'middle'
          cc.move_to(x, y + (layout.height - ink_extents.height) / (2 * Pango::SCALE))
        when 'bottom'
          cc.move_to(x, y + (layout.height - ink_extents.height) / Pango::SCALE)
        end
      end
    end

    # :nodoc:
    # @api private
    def set_wh!(layout, width, height)
      layout.width = width * Pango::SCALE unless width.nil? || width == :native
      layout.height = height * Pango::SCALE unless height.nil? || height == :native
      layout
    end

    # :nodoc:
    # @api private
    def text(str, font, font_size, color,
             x, y, width, height,
             markup, justify, wrap, ellipsize,
             spacing, align, valign, hint, angle)
      Squib.logger.debug {"Placing '#{str}'' with font '#{font}' @ #{x}, #{y}, color: #{color}, angle: #{angle} etc."}
      extents = nil
      use_cairo do |cc|
        cc.set_source_color(color)
        cc.translate(x,y)
        cc.rotate(angle)
        cc.translate(-1*x,-1*y)
        cc.move_to(x,y)

        layout = cc.create_pango_layout
        font_desc = Pango::FontDescription.new(font)
        font_desc.size = font_size * Pango::SCALE unless font_size.nil?
        layout.font_description = font_desc
        layout.text = str.to_s
        layout.markup = str.to_s if markup
        set_wh!(layout, width, height)
        set_wrap!(layout, wrap)
        set_ellipsize!(layout, ellipsize)
        set_align!(layout, align)
        layout.justify = justify unless justify.nil?
        layout.spacing = spacing * Pango::SCALE unless spacing.nil?
        cc.update_pango_layout(layout)
        valign!(cc, layout, x, y, valign)
        cc.update_pango_layout(layout) ; cc.show_pango_layout(layout)
        draw_text_hint(cc,x,y,layout,hint,angle)
        extents = { width: layout.extents[1].width / Pango::SCALE,
                    height: layout.extents[1].height / Pango::SCALE }
      end
      return extents
    end

  end
end
