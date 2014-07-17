module Squib
  class Card

    def png(file, x, y)
      cc = cairo_context
      png = Cairo::ImageSurface.from_png(file)
      cc.set_source(png, x, y)
      cc.paint
    end

    def svg(file, x, y)
      require 'rsvg2'
      svg = RSVG::Handle.new_from_file(file)
      tmp = Cairo::ImageSurface.new(svg.width, svg.height)
      tmp_cc = Cairo::Context.new(tmp)
      tmp_cc.render_rsvg_handle(svg, width: 400, height: 400)
      cairo_context.set_source(tmp, x, y)
      cairo_context.paint
    end

  end
end