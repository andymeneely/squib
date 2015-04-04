require 'pango'

module Squib
  class Card

    # :nodoc:
    # @api private
    def draw_text_hint(cc,x,y,layout, color,angle)
      color = @deck.text_hint if color.eql? 'off' and not @deck.text_hint.to_s.eql? 'off'
      return if color.to_s.eql? 'off' or color.nil?
      # when w,h < 0, it was never set. extents[1] are ink extents
      w = layout.width / Pango::SCALE
      w = layout.extents[1].width / Pango::SCALE if w < 0
      h = layout.height / Pango::SCALE
      h = layout.extents[1].height / Pango::SCALE if h < 0
      cc.rounded_rectangle(0, 0, w, h, 0, 0)
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
    def compute_valign(layout, valign)
      return 0 unless layout.height > 0
      ink_extents = layout.extents[1]
      case valign.to_s.downcase
      when 'middle'
        Pango.pixels( (layout.height - ink_extents.height) / 2)
      when 'bottom'
        Pango.pixels(layout.height - ink_extents.height)
      else
        0
      end
    end

    # :nodoc:
    # @api private
    def set_wh!(layout, width, height)
      layout.width  = width * Pango::SCALE unless width.nil? || width == :native
      layout.height = height * Pango::SCALE unless height.nil? || height == :native
    end

    # :nodoc:
    # @api private
    def next_embed(keys, str)
      ret     = nil
      ret_key = nil
      keys.each do |key|
        i = str.index(key)
        ret ||= i
        unless i.nil? || i > ret
          ret = i
          ret_key = key
        end
      end
      ret_key
    end

    # When we do embedded icons, we create a 3-character string that has a font
    # size of zero and a letter-spacing that fits the icon we need. That gives
    # us the wrapping behavior we need but no clutter beneath.  On most
    # platforms, this works fine. On Linux, this creates
    # a Cairo transformation matrix that
    ZERO_WIDTH_CHAR_SIZE = 0 # this works on most platforms
    # some platforms make this Pango pixels (1/1024), others a 1 pt font
    ZERO_WIDTH_CHAR_SIZE = 1 if RbConfig::CONFIG['host_os'] === 'linux-gnu'

    # :nodoc:
    # @api private
    def process_embeds(embed, str, layout)
      return [] unless embed.rules.any?
      layout.markup   = str
      clean_str       = layout.text
      draw_calls = []
      searches = []
      while (key = next_embed(embed.rules.keys, clean_str)) != nil
        rule          = embed.rules[key]
        spacing       = rule[:width] * Pango::SCALE
        index         = clean_str.index(key)
        str.sub!(key, "<span size=\"#{ZERO_WIDTH_CHAR_SIZE}\">a<span letter_spacing=\"#{spacing.to_i}\">a</span>a</span>")
        layout.markup = str
        clean_str     = layout.text
        searches << { index: index, rule: rule }
      end
      # byebug
      searches.each do |search|
        rect          = layout.index_to_pos(search[:index])
        x             = Pango.pixels(rect.x) + search[:rule][:dx]
        y             = Pango.pixels(rect.y) + search[:rule][:dy]
        draw_calls << {x: x, y: y, draw: search[:rule][:draw]} # defer drawing until we've valigned
      end
      return draw_calls
    end

    # :nodoc:
    # @api private
    def text(embed,str, font, font_size, color,
             x, y, width, height,
             markup, justify, wrap, ellipsize,
             spacing, align, valign, hint, angle)
      Squib.logger.debug {"Placing '#{str}'' with font '#{font}' @ #{x}, #{y}, color: #{color}, angle: #{angle} etc."}
      extents = nil
      str = str.to_s
      use_cairo do |cc|
        cc.set_source_squibcolor(color)
        cc.translate(x,y)
        cc.rotate(angle)
        cc.move_to(0, 0)

        font_desc      = Pango::FontDescription.new(font)
        font_desc.size = font_size * Pango::SCALE unless font_size.nil?
        layout         = cc.create_pango_layout
        layout.font_description = font_desc
        layout.text    = str
        layout.markup  = str if markup

        set_wh!(layout, width, height)
        set_wrap!(layout, wrap)
        set_ellipsize!(layout, ellipsize)
        set_align!(layout, align)

        layout.justify = justify unless justify.nil?
        layout.spacing = spacing * Pango::SCALE unless spacing.nil?
        cc.update_pango_layout(layout)

        embed_draws    = process_embeds(embed, str, layout)

        vertical_start = compute_valign(layout, valign)
        cc.move_to(0, vertical_start)

        cc.update_pango_layout(layout)
        cc.show_pango_layout(layout)
        begin
          embed_draws.each { |ed| ed[:draw].call(self, ed[:x], ed[:y] + vertical_start) }
        rescue Exception => e
          puts "====EXCEPTION!===="
          puts e
          puts "If this was a non-invertible matrix error, this is a known issue with a potential workaround. Please report it at: https://github.com/andymeneely/squib/issues/55"
          puts "=================="
          raise e
        end
        draw_text_hint(cc, x, y, layout, hint, angle)
        extents = { width: layout.extents[1].width / Pango::SCALE,
                    height: layout.extents[1].height / Pango::SCALE }
      end
      return extents
    end

  end
end
