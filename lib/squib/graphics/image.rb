module Squib

  # Cache all pngs we've already loaded
  #
  # :nodoc:
  # @api private
  def cache_load_image(file)
    @img_cache ||= {}
    @img_cache[file] || @img_cache[file] = Cairo::ImageSurface.from_png(file)
  end
  module_function :cache_load_image

  class Card

    # :nodoc:
    # @api private
    def png(file, x, y, alpha, blend)
      return if file.nil? or file.eql? ''
      png = Squib.cache_load_image(file)
      use_cairo do |cc|
        cc.set_source(png, x, y)
        cc.operator = blend unless blend == :none
        cc.paint(alpha)
      end
    end

    # :nodoc:
    # @api private
    def svg(file, id, x, y, width, height, alpha, blend)
      Squib.logger.debug {"Rendering: #{file}, #{id} #{x}, #{y}, #{width}, #{height}, #{alpha}, #{blend}"}
      return if file.nil? or file.eql? ''
      svg = RSVG::Handle.new_from_file(file)
      width = svg.width if width == :native
      height = svg.height if height == :native
      tmp = Cairo::ImageSurface.new(width, height)
      tmp_cc = Cairo::Context.new(tmp)
      tmp_cc.scale(width.to_f / svg.width.to_f, height.to_f / svg.height.to_f)
      tmp_cc.render_rsvg_handle(svg, id)
      use_cairo do |cc|
        cc.set_source(tmp, x, y)
        cc.operator = blend unless blend == :none
        cc.paint(alpha)
      end
    end

  end
end
