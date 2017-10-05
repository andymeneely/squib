require 'yaml'

module Squib
  # Internal class for handling layouts
  # @api private
  class LayoutParser

    def initialize(dpi = 300)
      @dpi = dpi
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
      "#{File.dirname(__FILE__)}/layouts/#{file}"
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
      h = {}
      parent_keys.each do |parent_key|
        from_extends = yml[key].merge(recurse_extends(yml, parent_key, visited)) do |key, child_val, parent_val|
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
        h = h.merge(from_extends) do |key, older_sibling, younger_sibling|
          younger_sibling # when two siblings have the same entry, the "younger" (lower one) overrides
        end
      end
      return h
    end

    def add_parent_child(parent, child)
      parent_pixels = Args::UnitConversion.parse(parent, @dpi).to_f
      child_pixels = Args::UnitConversion.parse(child.sub('+=', ''), @dpi).to_f
      parent_pixels + child_pixels
    end

    def sub_parent_child(parent, child)
      parent_pixels = Args::UnitConversion.parse(parent, @dpi).to_f
      child_pixels = Args::UnitConversion.parse(child.sub('-=', ''), @dpi).to_f
      parent_pixels - child_pixels
    end

    def mul_parent_child(parent, child)
      parent_pixels = Args::UnitConversion.parse(parent, @dpi).to_f
      child_float = child.sub('*=', '').to_f
      parent_pixels * child_float
    end

    def div_parent_child(parent, child)
      parent_pixels = Args::UnitConversion.parse(parent, @dpi).to_f
      child_float = child.sub('/=', '').to_f
      parent_pixels / child_float
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
      exists = true
      Array(yml[key]['extends']).each do |parent|
        unless yml.key?(parent)
          exists = false unless
          Squib.logger.error "Processing layout: '#{key}' attempts to extend a missing '#{yml[key]['extends']}'"
        end
      end
      return exists
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
