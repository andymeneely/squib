# typed: true
require 'yaml'
require_relative 'args/xywh_shorthands'

module Squib
  # Internal class for handling layouts
  # @api private
  class LayoutParser
    include Args::XYWHShorthands

    def initialize(dpi = 300, cell_px = 37.5)
      @dpi = dpi
      @cell_px = cell_px
    end

    # Load the layout file(s), if exists
    # @api private
    def load_layout(files, initial = {})
      layout = initial
      Squib::logger.info { "  using layout(s): #{files}" }
      Array(files).each do |file|
        thefile = file
        thefile = builtin(file) unless File.exists?(file)
        if File.exists? thefile
          # note: YAML.load_file returns false on empty file
          yml = layout.merge(YAML.load_file(thefile) || {})
          yml.each do |key, value|
            layout[key] = recurse_extends(yml, key, {})
          end
        else
          Squib::logger.error { "Layout file not found: #{file}. Skipping..." }
        end
      end
      return layout
    end

    private

    # Determine the file path of the built-in layout file
    def builtin(file)
      "#{File.dirname(__FILE__)}/builtin/layouts/#{file}"
    end

    # Process the extends recursively
    # :nodoc:
    # @api private
    def recurse_extends(yml, key, visited)
      assert_not_visited(key, visited)
      return yml[key] unless has_extends?(yml, key)
      return yml[key] unless parents_exist?(yml, key)
      visited[key] = key
      parent_keys = [yml[key]['extends']].flatten
      h = Hash.new
      parent_keys.each do |parent_key|
        from_extends = yml[key].merge(recurse_extends(yml, parent_key, visited)) do |key, child_val, parent_val|
          handle_relative_operators(parent_val, child_val)
        end
        h = h.merge(from_extends) do |key, older_sibling, younger_sibling|
          # In general, go with the younger sibling.
          # UNLESS that younger sibling had a relative operator, in which use the
          # (already computed) relative operator applied, which lands in older_sibling
          # See bug 244.
          sibling = younger_sibling
          %w(+= -= *= /=).each do |op|
            sibling = older_sibling if younger_sibling.to_s.strip.start_with? op
          end
          sibling
        end
      end
      return h
    end

    def handle_relative_operators(parent_val, child_val)
      if uses_operator?(child_val) && !has_digits?(parent_val) && !has_digits?(child_val)
        raise "Layout parse error: can't combine #{parent_val} and #{child_val}"
      end
      if child_val.to_s.strip.start_with?('+=')
        add_parent_child(parent_val, child_val)
      elsif child_val.to_s.strip.start_with?('-=')
        sub_parent_child(parent_val, child_val)
      elsif child_val.to_s.strip.start_with?('*=')
        mul_parent_child(parent_val, child_val)
      elsif child_val.to_s.strip.start_with?('/=')
        div_parent_child(parent_val, child_val)
      else
        child_val # child overrides parent when merging, no +=
      end
    end

    def add_parent_child(parent, child)
      parent_pixels = Args::UnitConversion.parse(parent, @dpi, @cell_px).to_f
      child_pixels = Args::UnitConversion.parse(child.sub('+=', ''), @dpi, @cell_px).to_f
      parent_pixels + child_pixels
    end

    def sub_parent_child(parent, child)
      parent_pixels = Args::UnitConversion.parse(parent, @dpi, @cell_px).to_f
      child_pixels = Args::UnitConversion.parse(child.sub('-=', ''), @dpi, @cell_px).to_f
      parent_pixels - child_pixels
    end

    def mul_parent_child(parent, child)
      parent_pixels = Args::UnitConversion.parse(parent, @dpi, @cell_px).to_f
      child_float = child.sub('*=', '').to_f
      parent_pixels * child_float
    end

    def div_parent_child(parent, child)
      parent_pixels = Args::UnitConversion.parse(parent, @dpi, @cell_px).to_f
      child_float = child.sub('/=', '').to_f
      parent_pixels / child_float
    end

    # For relative operators, it's difficult for us to handle
    # some of the shorthands - so let's just freak out if you're trying to use
    # relative operators with words, e.g. "middle += 0.5in"
    def has_digits?(arg)
      /.*\d.*/ === arg.to_s
    end

    def uses_operator?(arg)
      /^[+=|\-=|\/=|*=].*/ === arg.to_s
    end

    # Does this layout entry have an extends field?
    # i.e. is it a base-case or will it need recursion?
    # :nodoc:
    # @api private
    def has_extends?(yml, key)
      !!yml[key] && yml[key].key?('extends')
    end

    # Checks if we have any absentee parents
    # @api private
    def parents_exist?(yml, key)
      parented = Array(yml[key]['extends']).all? { |parent| yml.key? parent }
      Squib.logger.error "Processing layout: '#{key}' attempts to extend a missing '#{yml[key]['extends']}'" unless parented
      return parented
    end

    # Safeguard against malformed circular extends
    # :nodoc:
    # @api private
    def assert_not_visited(key, visited)
      if visited.key? key
        raise "Invalid layout: circular extends with '#{key}'"
      end
    end

  end
end
