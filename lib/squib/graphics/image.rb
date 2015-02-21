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
    def png(file, x, y, width, height, alpha, blend, angle, mask)
      Squib.logger.debug {"Rendering: #{file} @#{x},#{y} #{width}x#{height}, alpha: #{alpha}, blend: #{blend}, angle: #{angle}, mask: #{mask}"}
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
        cc.translate(-x, -y)
        cc.set_source(png, x, y)
        cc.operator = blend unless blend == :none
        if mask.nil?
          cc.paint(alpha)
        else
          cc.set_source_squibcolor(mask)
          cc.mask(png, x, y)
        end
      end
    end

    # :nodoc:
    # @api private
    def svg(file, id, x, y, width, height, alpha, blend, angle, mask)
      Squib.logger.debug {"Rendering: #{file}, id: #{id} @#{x},#{y} #{width}x#{height}, alpha: #{alpha}, blend: #{blend}, angle: #{angle}, mask: #{mask}"}
      return if file.nil? or file.eql? ''
      svg          = RSVG::Handle.new_from_file(file)
      width        = svg.width  if width == :native
      height       = svg.height if height == :native
      scale_width  = width.to_f / svg.width.to_f
      scale_height = height.to_f / svg.height.to_f
      use_cairo do |cc|
        cc.translate(x, y)
        cc.rotate(angle)
        cc.scale(scale_width, scale_height)
        cc.operator = blend unless blend == :none
        #FIXME Alpha is no longer used since we are not using cc.paint anymore
        if mask.nil?
          cc.render_rsvg_handle(svg, id)
        else
          tmp = Cairo::ImageSurface.new(width / scale_width, height / scale_height)
          tmp_cc = Cairo::Context.new(tmp)
          tmp_cc.render_rsvg_handle(svg, id)
          cc.set_source_squibcolor(mask)
          cc.mask(tmp, 0, 0)
        end
      end
    end

  end
end
