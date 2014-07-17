require 'pango'

module Squib
  class Card

    def draw_text_hint(x,y,layout, color)
      return if color.nil? && @deck.text_hint.nil? 
      color ||= @deck.text_hint
      w = layout.width / Pango::SCALE
      w = layout.extents[1].width / Pango::SCALE if w < 0 #i.e. was never set   
      h = layout.height / Pango::SCALE
      h = layout.extents[1].height / Pango::SCALE if h < 0 #i.e. was never set
      draw_rectangle(x,y,w,h,0,0,color)
    end

    def ellipsize(layout, options)
      unless options[:ellipsize].nil?
        h = { :none   => Pango::Layout::ELLIPSIZE_NONE,
              :start  => Pango::Layout::ELLIPSIZE_START,
              :middle => Pango::Layout::ELLIPSIZE_MIDDLE,
              :end    => Pango::Layout::ELLIPSIZE_END,
              true    => Pango::Layout::ELLIPSIZE_END,
              false   => Pango::Layout::ELLIPSIZE_NONE
            }
        layout.ellipsize = h[options[:ellipsize]]
      end
      layout
    end

    def wrap(layout, options)
      unless options[:wrap].nil?
        h = { :word  => Pango::Layout::WRAP_WORD,
              :char => Pango::Layout::WRAP_CHAR,
              :word_char    => Pango::Layout::WRAP_WORD_CHAR,
              true    => Pango::Layout::WRAP_WORD_CHAR,
            }
        layout.wrap = h[options[:wrap]]
      end
      layout
    end

    def align(layout, options)
      unless options[:align].nil?
          h = { :left => Pango::ALIGN_LEFT,
                :right => Pango::ALIGN_RIGHT,
                :center => Pango::ALIGN_CENTER
              }
          layout.alignment = h[options[:align]]
      end
      layout
    end

    def setwh(layout, options)
      layout.width = options[:width] * Pango::SCALE unless options[:width].nil?
      layout.height = options[:height] * Pango::SCALE unless options[:height].nil?
      layout
    end

    def fitxy(layout, x,y, options)
      w = options[:width] ; h = options[:height] 
      w ||= (@width - 2*x); h ||= (@height - 2*y) # default centers to x,y 
      w *= Pango::SCALE   ; h *= Pango::SCALE    
      layout.width=w      ; layout.height=h
      layout
    end

    def text(str, font, x, y, color, options)
      cc = cairo_context
      cc.set_source_color(color)
      cc.move_to(x,y)
      layout = cc.create_pango_layout
      layout.text = str.to_s
      layout.markup = str.to_s if options[:markup]
      layout = setwh(layout, options) unless options[:width].nil? && options[:height].nil?
      layout = fitxy(layout, x, y , options) if options[:fitxy]
      layout = wrap(layout, options)
      layout = ellipsize(layout, options)
      layout = align(layout, options)
      layout.justify = options[:justify] unless options[:justify].nil?
      layout.font_description = Pango::FontDescription.new(font)
      cc.update_pango_layout(layout)
      cc.show_pango_layout(layout)
      draw_text_hint(x,y,layout,options[:hint])
    end

  end
end