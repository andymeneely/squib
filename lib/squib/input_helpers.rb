require 'squib/constants'
require 'squib/args/unit_conversion'

module Squib
  # :nodoc:
  # @api private
  module InputHelpers

    # :nodoc:
    # @api private
    def needs(opts, params)
      Squib.logger.debug {"Method #{caller(1,1)} was given the following opts: #{opts}"}
      opts = layoutify(opts) if params.include? :layout
      opts = Squib::SYSTEM_DEFAULTS.merge(opts)
      opts = expand_singletons(opts, params)
      opts = rangeify(opts) if params.include? :range
      opts = fileify(opts) if params.include? :file
      opts = fileify(opts, false) if params.include? :file_to_save
      opts = colorify(opts, true) if params.include? :nillable_color
      opts = dirify(opts, :dir, true) if params.include? :creatable_dir
      opts = dirify(opts, :img_dir, false) if params.include? :img_dir
      opts = fileify(opts, false) if params.include? :files
      opts = colorify(opts) if params.include? :color
      opts = colorify(opts, false, :fill_color) if params.include? :fill_color
      opts = colorify(opts, false, :stroke_color) if params.include? :stroke_color
      opts = fontify(opts) if params.include? :font
      opts = radiusify(opts) if params.include? :rect_radius
      opts = svgidify(opts) if params.include? :svgid
      opts = formatify(opts) if params.include? :formats
      opts = rotateify(opts) if params.include? :rotate
      opts = rowify(opts) if params.include? :rows
      opts = faceify(opts) if params.include? :face
      opts = convert_units(opts, params)
      opts
    end
    module_function :needs

    # :nodoc:
    # @api private
    def expand_singletons(opts, needed_params)
      Squib::EXPANDING_PARAMS.each_pair do |param_name, api_param|
        if needed_params.include? param_name
          unless opts[api_param].respond_to?(:each)
            opts[api_param] = [opts[api_param]] * @cards.size
          end
        end
      end
      Squib.logger.debug {"After expand_singletons: #{opts}"}
      opts
    end
    module_function :expand_singletons

    # Layouts have to come before, so we repeat expand_singletons here
    # :nodoc:
    # @api private
    def layoutify(opts)
      unless opts[:layout].respond_to?(:each)
        opts[:layout] = [opts[:layout]] * @cards.size
      end
      opts[:layout].each_with_index do |layout, i|
        unless layout.nil?
          entry = @layout[layout.to_s]
          unless entry.nil?
            entry.each do |key, value|
              opts[key.to_sym] = [] if opts[key.to_sym].nil?
              opts[key.to_sym][i] ||= entry[key] #don't override if it's already there
            end
          else
            Squib.logger.warn ("Layout entry '#{layout}' does not exist." )
          end
        end
      end
      Squib.logger.debug {"After layoutify: #{opts}"}
      opts
    end
    module_function :layoutify

    # :nodoc:
    # @api private
    def formatify(opts)
      opts[:format] = [opts[:format]].flatten
      opts
    end
    module_function :formatify

    # :nodoc:
    # @api private
    def rangeify (opts)
      range = opts[:range]
      raise 'Range cannot be nil' if range.nil?
      range = 0..(@cards.size-1) if range == :all
      range = range..range if range.is_a? Integer
      if range.max > (@cards.size-1)
        raise ArgumentError.new("#{range} is outside of deck range of 0..#{@cards.size-1}")
      end
      opts[:range] = range
      Squib.logger.debug {"After rangeify: #{opts}"}
      opts
    end
    module_function :rangeify

    # :nodoc:
    # @api private
    def fileify(opts, file_must_exist=true)
      [opts[:file]].flatten.each do |file|
        if file_must_exist and !File.exists?(file)
          raise "File #{File.expand_path(file)} does not exist!"
        end
      end
      opts
    end
    module_function :fileify

    # :nodoc:
    # @api private
    def dirify(opts, key, allow_create=false)
      return opts if Dir.exists?(opts[key])
      if allow_create
        Squib.logger.warn("Dir '#{opts[key]}' does not exist, creating it.")
        Dir.mkdir opts[key]
        return opts
      else
        raise "'#{opts[key]}' does not exist!"
      end
    end
    module_function :dirify

    # :nodoc:
    # @api private
    def colorify(opts, nillable=false, key=:color)
      opts[key].each_with_index do |color, i|
        unless nillable && color.nil?
          if custom_colors.key? color.to_s
            color = custom_colors[color.to_s]
          end
          opts[key][i] = color
        end
      end
      Squib.logger.debug {"After colorify: #{opts}"}
      opts
    end
    module_function :colorify

    # :nodoc:
    # @api private
    def fontify (opts)
      opts[:font].each_with_index do |font, i|
        opts[:font][i] = @font if font==:use_set
        opts[:font][i] = Squib::SYSTEM_DEFAULTS[:default_font] if font == :default
      end
      Squib.logger.debug {"After fontify: #{opts}"}
      opts
    end
    module_function :fontify

    # :nodoc:
    # @api private
    def radiusify(opts)
      opts[:radius].each_with_index do |radius, i|
        unless radius.nil?
          opts[:x_radius][i] = radius
          opts[:y_radius][i] = radius
        end
      end
      Squib.logger.debug {"After radiusify: #{opts}"}
      opts
    end
    module_function :radiusify

    # :nodoc:
    # @api private
    def svgidify(opts)
      opts[:id].each_with_index do |id, i|
        unless id.nil?
          opts[:id][i] = '#' << id unless id.start_with? '#'
        end
      end
      Squib.logger.debug {"After svgidify: #{opts}"}
      opts
    end
    module_function :svgidify

    # :nodoc:
    # @api private
    def rotateify(opts)
      case opts[:rotate]
      when true, :clockwise
        opts[:angle] = 0.5 * Math::PI
      when :counterclockwise
        opts[:angle] = 1.5 * Math::PI
      end
      Squib.logger.debug {"After rotateify: #{opts}"}
      opts
    end
    module_function :rotateify

    # Convert units
    # :nodoc:
    # @api private
    def convert_units(opts, needed_params)
      UNIT_CONVERSION_PARAMS.each_pair do |param_name, api_param|
        if needed_params.include? param_name
          if EXPANDING_PARAMS.include? param_name
            opts[api_param].each_with_index do |arg, i|
              opts[api_param][i] = Args::UnitConversion.parse(arg, @dpi)
            end
          else #not an expanding param
            opts[api_param] = Args::UnitConversion.parse(opts[api_param], @dpi)
          end
        end
      end
      Squib.logger.debug {"After convert_units: #{opts}"}
      return opts
    end
    module_function :convert_units

     # Handles expanding rows. If the "rows" does not respond to to_i (e.g. :infinite),
    # then compute what we need based on number of cards and number of columns.
    # :nodoc:
    # @api private
    def rowify(opts)
      unless opts[:rows].respond_to? :to_i
        raise "Columns must be an integer" unless opts[:columns].respond_to? :to_i
        opts[:rows] = (@cards.size / opts[:columns].to_i).ceil
      end
      opts
    end

    # Used for showcase - face right if it's :right
    # :nodoc:
    # @api private
    def faceify(opts)
      opts[:face] = (opts[:face].to_s.downcase == 'right')
      opts
    end

  end
end
