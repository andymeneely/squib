require 'squib/constants'

module Squib
  # :nodoc:
  # @api private
  module InputHelpers

    # :nodoc:
    # @api private
    def needs(opts, params)
      opts = layoutify(opts) if params.include? :layout
      opts = Squib::SYSTEM_DEFAULTS.merge(opts)
      opts = rangeify(opts) if params.include? :range      
      opts = fileify(opts) if params.include? :file
      opts = fileify(opts, false, false) if params.include? :file_to_save
      opts = fileify(opts, true, false) if params.include? :files
      opts = colorify(opts) if params.include? :color
      opts = colorify(opts, false, :fill_color) if params.include? :fill_color
      opts = colorify(opts, false, :stroke_color) if params.include? :stroke_color
      opts = colorify(opts, true) if params.include? :nillable_color
      opts = dirify(opts) if params.include? :dir
      opts = dirify(opts, true) if params.include? :creatable_dir
      opts = fontify(opts) if params.include? :font
      opts = radiusify(opts) if params.include? :radius
      opts = svgidify(opts) if params.include? :svgid
      opts = formatify(opts) if params.include? :formats
      opts
    end
    module_function :needs

    # :nodoc:
    # @api private
    def layoutify(opts)
      unless opts[:layout].nil?
        entry = @layout[opts[:layout].to_s]
        unless entry.nil?
          entry.each do |key, value|
            opts[key.to_sym] ||= entry[key]
          end
        else 
          Squib.logger.warn "Layout entry '#{opts[:layout]}' does not exist." 
        end
      end
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
      opts
    end
    module_function :rangeify

    # :nodoc:
    # @api private
    def fileify(opts, expand_singletons=false, file_must_exist=true)
      opts[:file] = [opts[:file]] * @cards.size if expand_singletons && !(opts[:file].respond_to? :each)
      files = [opts[:file]].flatten
      files.each do |file|
        if file_must_exist and !File.exists?(file) 
          raise "File #{File.expand_path(file)} does not exist!"
        end
      end
      opts
    end
    module_function :fileify

    # :nodoc:
    # @api private
    def dirify(opts, allow_create=false)
      return opts if Dir.exists?(opts[:dir])
      if allow_create
        Squib.logger.warn "Dir #{opts[:dir]} does not exist, creating it."
        Dir.mkdir opts[:dir]
        return opts 
      else
        raise "'#{opts[:dir]}' does not exist!"
      end
    end
    module_function :dirify

    # :nodoc:
    # @api private
    def colorify(opts, nillable=false, key=:color)
      return opts if nillable && opts[key].nil?
      if @custom_colors.key? opts[key].to_s
        opts[key] = @custom_colors[opts[key].to_s]
      end
      opts[key] = Cairo::Color.parse(opts[key])
      opts
    end
    module_function :colorify

    # :nodoc:
    # @api private
    def fontify (opts)
      opts[:font] = @font if opts[:font]==:use_set
      opts[:font] = Squib::SYSTEM_DEFAULTS[:default_font] if opts[:font] == :default
      opts 
    end
    module_function :fontify 

    # :nodoc:
    # @api private
    def radiusify(opts)
      unless opts[:radius].nil?
        opts[:x_radius] = opts[:radius]
        opts[:y_radius] = opts[:radius]
      end
      opts
    end
    module_function :radiusify

    # :nodoc:
    # @api private
    def svgidify(opts)
      unless opts[:id].nil?
        opts[:id] = '#' << opts[:id] unless opts[:id].start_with? '#'
      end
      opts
    end
    module_function :svgidify

  end
end