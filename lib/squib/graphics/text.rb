require 'pango'
require_relative '../args/typographer'
require_relative 'embedding_utils'

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
    def compute_valign(layout, valign, embed_h)
      return 0 unless layout.height > 0
      ink_extents = layout.extents[1]
      ink_extents.height = embed_h * Pango::SCALE if ink_extents.height == 0 # JUST embed, bug #134
      case valign.to_s.downcase
      when 'middle'
        Pango.pixels((layout.height - ink_extents.height) / 2)
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

    # Compute the width of the carve that we need
    def compute_carve(rule, range)
      w = rule[:box].width[@index]
      if w == :native
        file = rule[:file][@index].file
        case rule[:type]
        when :png
          Squib.cache_load_image(file).width.to_f / (range.size - 1)
        when :svg
          svg_data = rule[:svg_args].data[@index]
          unless file.to_s.empty? || svg_data.to_s.empty?
            Squib.logger.warn 'Both an SVG file and SVG data were specified'
          end
          return 0 if (file.nil? or file.eql? '') and svg_data.nil?
          svg_data = File.read(file) if svg_data.to_s.empty?
          RSVG::Handle.new_from_data(svg_data).width
        end
      else
        rule[:box].width[@index] * Pango::SCALE / (range.size - 1)
      end
    end

    # # :nodoc:
    # # @api private
    def embed_images!(embed, str, layout, valign, scale)
      return [] unless embed.rules.any?
      layout.markup = str
      clean_str     = layout.text
      attrs = layout.attributes || Pango::AttrList.new
      EmbeddingUtils.indices(clean_str, embed.rules.keys).each do |key, ranges|
        rule = embed.rules[key]
        ranges.each do |range|
          carve = Pango::Rectangle.new(0, 0, compute_carve(rule, range) * scale, 0)
          att = Pango::AttrShape.new(carve, carve, rule)
          att.start_index = range.first
          att.end_index = range.first+1
          attrs.insert(att)

          # Add an empty draw for all but the first characters in the key, so they
          # don't appear in the output, but we only draw the actual symbol once
          att_nodraw = Pango::AttrShape.new(carve, carve, "nodraw")
          att_nodraw.start_index = range.first + 1
          att_nodraw.end_index = range.last
          attrs.insert(att_nodraw)

        end
      end
      layout.attributes = attrs
      layout.context.set_shape_renderer do |cxt, att, do_path|
        unless do_path || att.data == "nodraw" # when stroking the text
          rule = att.data
          x = Pango.pixels(layout.index_to_pos(att.start_index).x) +
              rule[:adjust].dx[@index]
          y = Pango.pixels(layout.index_to_pos(att.start_index).y) +
                rule[:adjust].dy[@index] +
                compute_valign(layout, valign, rule[:box].height[@index])
          rule[:draw].call(self, x, y, scale)
          cxt.reset_clip
          [cxt, att, do_path]
        end
      end
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

    # @api private
    def text(embed, para, box, trans, draw, dpi)
        font_desc = Pango::FontDescription.new(para.font)
        font_desc.size = para.font_size * Pango::SCALE if para.font_size.is_a? Numeric
        orig_font_size = font_desc.size
        
        # If text autoscaling is enabled, find the largest text size (smaller or equal to the set text size) that fits
        if para.ellipsize == :autoscale
            para.ellipsize = Pango::EllipsizeMode::END
            sizes = sizes = (1 .. font_desc.size).to_a.reverse
            
            # Dummy render to an area outside the card with decreasing font sizes until text no longer ellipsizes
            max_fitting_size = sizes.bsearch{ |sz|
                font_desc.size = sz
                extents = render_text(embed, para, box, trans, draw, dpi, font_desc, orig_font_size, true)
                !extents[:ellipsized]
            }
            
            if max_fitting_size.nil?
                max_fitting_size = sizes.last
                Squib.logger.warn{"Could not autosize for Card \##{@index} as minimum specified size #{max_fitting_size} still ellipsizes."}
            end
            font_desc.size = max_fitting_size
        end

        render_text(embed, para, box, trans, draw, dpi, font_desc, orig_font_size, false)
    end

    # :nodoc:
    # @api private
    def render_text(embed, para, box, trans, draw, dpi, font_desc, orig_font_size, dummy_draw)
      Squib.logger.debug {"Rendering text with: \n#{para} \nat:\n #{box} \ndraw:\n #{draw} \ntransform: #{trans}"}
      extents = nil
      use_cairo do |cc|
        cc.set_source_squibcolor(draw.color)
        cc.translate(box.x, box.y)
        cc.translate(-10000, -10000) if dummy_draw
        cc.rotate(trans.angle)
        cc.move_to(0, 0)

        layout         = cc.create_pango_layout
        layout.font_description = font_desc
        layout.text = para.str.to_s
        layout.context.resolution = dpi
        if para.markup
          para.str = @deck.typographer.process(layout.text)
          layout.markup = para.str.to_s
        end

        set_font_rendering_opts!(layout)
        set_wh!(layout, box.width, box.height)
        layout.wrap      = para.wrap
        layout.ellipsize = para.ellipsize
        layout.alignment = para.align

        layout.justify = para.justify unless para.justify.nil?
        layout.spacing = para.spacing unless para.spacing.nil?

        embed_images!(embed, para.str, layout, para.valign, font_desc.size / orig_font_size.to_f)

        vertical_start = compute_valign(layout, para.valign, 0)
        cc.move_to(0, vertical_start)

        stroke_outline!(cc, layout, draw) if draw.stroke_strategy == :stroke_first
        cc.move_to(0, vertical_start)

        cc.show_pango_layout(layout)
        stroke_outline!(cc, layout, draw) if draw.stroke_strategy == :fill_first
        draw_text_hint(cc, box.x, box.y, layout, para.hint)
        extents = { width: layout.extents[1].width / Pango::SCALE,
                    height: layout.extents[1].height / Pango::SCALE,
                    ellipsized: layout.ellipsized?}
        warn_if_ellipsized layout unless dummy_draw
      end
      return extents
    end

  end
end
