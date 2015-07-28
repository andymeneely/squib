require 'pango'
require 'squib/args/typographer'

module Squib
  class Card

    # :nodoc:
    # @api private
    def draw_text_hint(cc, x, y, layout, color)
      color = @deck.text_hint if color.to_s.eql? 'off' and not @deck.text_hint.to_s.eql? 'off'
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

    def set_font_rendering_opts!(layout)
      font_options                = Cairo::FontOptions.new
      font_options.antialias      = Conf::ANTIALIAS_OPTS[(@deck.antialias || 'gray').downcase]
      font_options.hint_metrics   = 'on' # TODO make this configurable
      font_options.hint_style     = 'full' # TODO make this configurable
      layout.context.font_options = font_options
    end

    # :nodoc:
    # @api private
    def set_wh!(layout, width, height)
      layout.width  = width * Pango::SCALE unless width.nil? || width == :auto
      layout.height = height * Pango::SCALE unless height.nil? || height == :auto
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
      layout.markup = str
      clean_str     = layout.text
      draw_calls    = []
      searches      = []
      while (key = next_embed(embed.rules.keys, clean_str)) != nil
        rule    = embed.rules[key]
        spacing = rule[:box].width[@index] * Pango::SCALE
        kindex   = clean_str.index(key)
        kindex   = clean_str[0..kindex].bytesize #convert to byte index (bug #57)
        str = str.sub(key, "<span size=\"#{ZERO_WIDTH_CHAR_SIZE}\">a<span letter_spacing=\"#{spacing.to_i}\">a</span>a</span>")
        layout.markup = str
        clean_str     = layout.text
        searches << { index: kindex, rule: rule }
      end
      searches.each do |search|
        rect = layout.index_to_pos(search[:index])
        x    = Pango.pixels(rect.x) + search[:rule][:adjust].dx[@index]
        y    = Pango.pixels(rect.y) + search[:rule][:adjust].dy[@index]
        draw_calls << {x: x, y: y, draw: search[:rule][:draw]} # defer drawing until we've valigned
      end
      return draw_calls
    end

    def stroke_outline!(cc, layout, draw)
      if draw.stroke_width > 0
        cc.pango_layout_path(layout)
        cc.fancy_stroke draw
        cc.set_source_squibcolor(draw.color)
      end
    end

    def warn_if_ellipsized(layout)
       if @deck.conf.warn_ellipsize? && layout.ellipsized?
         Squib.logger.warn { "Ellipsized (too much text). Card \##{@index}. Text:  \"#{layout.text}\". \n (To disable this warning, set warn_ellipsize: false in config.yml)" }
       end
    end

    # :nodoc:
    # @api private
    def text(embed, para, box, trans, draw)
      Squib.logger.debug {"Rendering text with: \n#{para} \nat:\n #{box} \ndraw:\n #{draw} \ntransform: #{trans}"}
      extents = nil
      use_cairo do |cc|
        cc.set_source_squibcolor(draw.color)
        cc.translate(box.x, box.y)
        cc.rotate(trans.angle)
        cc.move_to(0, 0)

        font_desc      = Pango::FontDescription.new(para.font)
        font_desc.size = para.font_size * Pango::SCALE unless para.font_size.nil?
        layout         = cc.create_pango_layout
        layout.font_description = font_desc
        layout.text    = para.str
        if para.markup
          para.str = @deck.typographer.process(layout.text)
          layout.markup = para.str
        end

        set_font_rendering_opts!(layout)
        set_wh!(layout, box.width, box.height)
        layout.wrap      = para.wrap
        layout.ellipsize = para.ellipsize
        layout.alignment = para.align

        layout.justify = para.justify unless para.justify.nil?
        layout.spacing = para.spacing unless para.spacing.nil?

        embed_draws    = process_embeds(embed, para.str, layout)

        vertical_start = compute_valign(layout, para.valign)
        cc.move_to(0, vertical_start) #TODO clean this up a bit

        stroke_outline!(cc, layout, draw) if draw.stroke_strategy == :stroke_first
        cc.move_to(0, vertical_start)
        cc.show_pango_layout(layout)
        stroke_outline!(cc, layout, draw) if draw.stroke_strategy == :fill_first
        begin
          embed_draws.each { |ed| ed[:draw].call(self, ed[:x], ed[:y] + vertical_start) }
        rescue Exception => e
          puts "====EXCEPTION!===="
          puts e
          puts "If this was a non-invertible matrix error, this is a known issue with a potential workaround. Please report it at: https://github.com/andymeneely/squib/issues/55"
          puts "=================="
          raise e
        end
        draw_text_hint(cc, box.x, box.y, layout, para.hint)
        extents = { width: layout.extents[1].width / Pango::SCALE,
                    height: layout.extents[1].height / Pango::SCALE }
        warn_if_ellipsized layout
      end
      return extents
    end

  end
end
