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

      Squib.logger.warn 'Text hints are broken on non-zero angles' if angle > 0
      cc.rounded_rectangle(x,y,w,h,0,0)
      cc.set_source_color(color)
      cc.set_line_width(2.0)
      cc.stroke
    end

    # :nodoc:
    # @api private 
    def ellipsize(layout, ellipsize)
      unless ellipsize.nil?
        h = { :none   => Pango::Layout::ELLIPSIZE_NONE,
              :start  => Pango::Layout::ELLIPSIZE_START,
              :middle => Pango::Layout::ELLIPSIZE_MIDDLE,
              :end    => Pango::Layout::ELLIPSIZE_END,
              true    => Pango::Layout::ELLIPSIZE_END,
              false   => Pango::Layout::ELLIPSIZE_NONE
            }
        layout.ellipsize = h[ellipsize]
      end
      layout
    end

    # :nodoc:
    # @api private 
    def wrap(layout, wrap)
      unless wrap.nil?
        h = { :word  => Pango::Layout::WRAP_WORD,
              :char => Pango::Layout::WRAP_CHAR,
              :word_char    => Pango::Layout::WRAP_WORD_CHAR,
              true    => Pango::Layout::WRAP_WORD_CHAR,
              false => nil,
              :none => nil
            }
        layout.wrap = h[wrap]
      end
      layout
    end

    # :nodoc:
    # @api private 
    def align(layout, align)
      unless align.nil?
          h = { :left => Pango::ALIGN_LEFT,
                :right => Pango::ALIGN_RIGHT,
                :center => Pango::ALIGN_CENTER
              }
          layout.alignment = h[align]
      end
      layout
    end

    # :nodoc:
    # @api private 
    def valign(cc, layout, x, y, valign)
      if layout.height > 0 
        ink_extents = layout.extents[1]
        case valign
        when :middle
          cc.move_to(x, y + (layout.height - ink_extents.height) / (2 * Pango::SCALE))
        when :bottom
          cc.move_to(x, y + (layout.height - ink_extents.height) / Pango::SCALE)
        end
      end
    end

    # :nodoc:
    # @api private 
    def setwh(layout, width, height)
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
      use_cairo do |cc|
        cc.set_source_color(color)
        cc.move_to(x,y)
        cc.rotate(angle)
        
        layout = cc.create_pango_layout
        font_desc = Pango::FontDescription.new(font)
        font_desc.size = font_size * Pango::SCALE unless font_size.nil?
        layout.font_description = font_desc
        layout.text = str.to_s
        layout.markup = str.to_s if markup
        layout = setwh(layout, width, height)
        layout = wrap(layout, wrap)
        layout = ellipsize(layout, ellipsize)
        layout = align(layout, align)
        layout.justify = justify unless justify.nil?
        layout.spacing = spacing * Pango::SCALE unless spacing.nil? 
        cc.update_pango_layout(layout) 
        valign(cc, layout, x,y, valign)
        cc.update_pango_layout(layout) ; cc.show_pango_layout(layout)
        draw_text_hint(cc,x,y,layout,hint,angle)
      end
    end

  end
end