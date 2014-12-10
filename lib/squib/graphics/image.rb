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
    def png(file, x, y, width, height, alpha, blend, angle)
      Squib.logger.debug {"Rendering: #{file} @#{x},#{y} #{width}x#{height}, alpha: #{alpha}, blend: #{blend}, angle: #{angle}"}
      return if file.nil? or file.eql? ''
      png = Squib.cache_load_image(file)
      use_cairo do |cc|
        cc.translate(x, y)
        if width != :native || height != :native
          width  == :native && width  = png.width.to_f
          height == :native && height = png.height.to_f
          Squib.logger.warn "PNG scaling results in antialiasing."
          cc.scale(width.to_f / png.width.to_f, height.to_f / png.height.to_f)
        end
        cc.rotate(angle)
        cc.translate(-1 * x, -1 * y)
        cc.set_source(png, x, y)
        cc.operator = blend unless blend == :none
        cc.paint(alpha)
      end
    end

    # :nodoc:
    # @api private
    def svg(file, id, x, y, width, height, alpha, blend, angle)
      Squib.logger.debug {"Rendering: #{file}, id: #{id} @#{x},#{y} #{width}x#{height}, alpha: #{alpha}, blend: #{blend}, angle: #{angle}"}
      return if file.nil? or file.eql? ''
      svg = RSVG::Handle.new_from_file(file)
      width = svg.width if width == :native
      height = svg.height if height == :native
      tmp = Cairo::ImageSurface.new(width, height)
      tmp_cc = Cairo::Context.new(tmp)
      tmp_cc.scale(width.to_f / svg.width.to_f, height.to_f / svg.height.to_f)
      tmp_cc.render_rsvg_handle(svg, id)
      use_cairo do |cc|
        cc.translate(x, y)
        cc.rotate(angle)
        cc.translate(-1 * x, -1 * y)
        cc.set_source(tmp, x, y)
        cc.operator = blend unless blend == :none
        cc.paint(alpha)
      end
    end

  end
end
