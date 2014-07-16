require 'pango'

module Squib
  class Card

    def text(str, font, x, y, options)
      cc = cairo_context
      cc.set_source_color(:black) #black
      cc.move_to(x,y)
      layout = cc.create_pango_layout
      layout.text = str.to_s
      w = options[:width] ; h = options[:height] 
      w ||= (@width - 2*x)  ; h ||= (@height - 2*y) # default centers to x,y 
      w *= Pango::SCALE   ; h *= Pango::SCALE    
      layout.width=w      ; layout.height=h
      layout.wrap = Pango::WRAP_WORD
      layout.justify = true
      layout.alignment = Pango::ALIGN_LEFT
      layout.font_description = Pango::FontDescription.new(font)
      #Center it vertically?
      #puts "Height: #{layout.extents[1].height / Pango::SCALE}"
      #puts "Height: #{layout.pixel_size[1]*layout.line_count}"
      cc.update_pango_layout(layout)
      cc.show_pango_layout(layout)
    end

  end
end