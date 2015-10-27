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
    def png(file, box, paint, trans)
      Squib.logger.debug {"RENDERING PNG: \n  file: #{file}\n  box: #{box}\n  paint: #{paint}\n  trans: #{trans}"}
      return if file.nil? or file.eql? ''
      png = Squib.cache_load_image(file)
      use_cairo do |cc|
        cc.translate(box.x, box.y)
        if box.width != :native || box.height != :native
          box.width  = png.width.to_f  if box.width  == :native
          box.height = png.height.to_f if box.height == :native
          box.width  = png.width.to_f * box.height.to_f / png.height.to_f if box.width == :scale
          box.height = png.height.to_f * box.width.to_f / png.width.to_f  if box.height == :scale
          Squib.logger.warn "PNG scaling results in aliasing."
          cc.scale(box.width.to_f / png.width.to_f, box.height.to_f / png.height.to_f)
        end
        cc.rotate(trans.angle)
        cc.translate(-box.x, -box.y)

        # cc.translate(trans.crop_x, trans.crop_y)
        trans.crop_width  = png.width.to_f  if trans.crop_width  == :native
        trans.crop_height = png.height.to_f if trans.crop_height == :native
        cc.rounded_rectangle(box.x, box.y, trans.crop_width, trans.crop_height, trans.crop_corner_x_radius, trans.crop_corner_y_radius)
        cc.clip
        cc.translate(-trans.crop_x, -trans.crop_y)

        cc.set_source(png, box.x, box.y)
        cc.operator = paint.blend unless paint.blend == :none
        if paint.mask.empty?
          cc.paint(paint.alpha)
        else
          cc.set_source_squibcolor(paint.mask)
          cc.mask(png, box.x, box.y)
        end
      end
    end

    # :nodoc:
    # @api private
    def svg(file, svg_args, box, paint, trans)
      Squib.logger.debug {"Rendering: #{file}, id: #{id} @#{x},#{y} #{width}x#{height}, alpha: #{alpha}, blend: #{blend}, angle: #{angle}, mask: #{mask}"}
      Squib.logger.warn 'Both an SVG file and SVG data were specified' unless file.to_s.empty? || svg_args.data.to_s.empty?
      return if (file.nil? or file.eql? '') and svg_args.data.nil? # nothing specified TODO Move this out to arg validator
      svg_args.data = File.read(file) if svg_args.data.to_s.empty?
      svg          = RSVG::Handle.new_from_data(svg_args.data)
      box.width    = svg.width  if box.width == :native
      box.height   = svg.height if box.height == :native
      box.width  = svg.width.to_f * box.height.to_f / svg.height.to_f if box.width == :scale
      box.height = svg.height.to_f * box.width.to_f / svg.width.to_f  if box.height == :scale
      scale_width  = box.width.to_f / svg.width.to_f
      scale_height = box.height.to_f / svg.height.to_f
      use_cairo do |cc|
        cc.translate(box.x, box.y)
        cc.rotate(trans.angle)
        cc.scale(scale_width, scale_height)
        cc.operator = paint.blend unless paint.blend == :none
        if paint.mask.to_s.empty?
          cc.render_rsvg_handle(svg, svg_args.id)
        else
          tmp = Cairo::ImageSurface.new(box.width / scale_width, box.height / scale_height)
          tmp_cc = Cairo::Context.new(tmp)
          tmp_cc.render_rsvg_handle(svg, svg_args.id)
          cc.set_source_squibcolor(paint.mask)
          cc.mask(tmp, 0, 0)
        end
      end
    end

  end
end
