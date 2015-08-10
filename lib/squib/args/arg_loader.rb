require 'squib/constants'
require 'squib/conf'
require 'ostruct'

module Squib
  # @api private
  module Args

    # Intended to be used a a mix-in,
    # For example use see Box as an example
    module ArgLoader

      # Main class invoked by the client (i.e. api/ methods)
      def load!(args, expand_by: 1, layout: {}, dpi: 300)
        Squib.logger.debug { "ARG LOADER: load! for #{self.class}, args: #{args}" }
        @dpi = dpi
        args[:layout] = prep_layout_args(args[:layout], expand_by: expand_by)
        expand_and_set_and_defaultify(args: args, by: expand_by, layout: layout)
        validate
        convert_units
        self
      end

      def expand_and_set_and_defaultify(args: {}, by: 1, layout: {})
        attributes = self.class.parameters.keys
        attributes.each do |p|
          args[p] = defaultify(p, args, layout)
          val = if expandable_singleton?(p, args[p])
                  [args[p]] * by
                else
                  args[p] # not an expanding parameter
                end
          instance_variable_set "@#{p}", val
        end
        self.class.class_eval { attr_reader *(attributes) }
      end

      # Must be:
      #  (a) an expanding parameter, and
      #  (b) a singleton already (i.e. doesn't respond to :each)
      def expandable_singleton?(p, arg)
        self.class.expanding_parameters.include?(p) && !arg.respond_to?(:each)
      end

      # Incorporate defaults and layouts
      #  (1) Use whatever is specified if it is
      #  (2) Go over all layout specifications (if any) and look them up
      #     - Use layout when it's specified for that card
      #     - Use "default" if no layout was specified, or the layout itself did not specify
      #           Defaut can be overriden for a given dsl method (@dsl_method_defaults)
      #           (e.g stroke width is 0.0 for text, non-zero everywhere else)
      #
      def defaultify(p, args, layout)
        return args[p] if args.key? p # arg was specified, no defaults used
        defaults = self.class.parameters.merge(@dsl_method_defaults || {})
        args[:layout].map do |layout_arg|
          return defaults[p] if layout_arg.nil?  # no layout specified, use default
          unless layout.key? layout_arg.to_s     # specified a layout, but it doesn't exist in layout. Oops!
            Squib.logger.warn("Layout \"#{layout_arg.to_s}\" does not exist in layout file - using default instead")
            return defaults[p]
          end
          if layout[layout_arg.to_s].key?(p.to_s)
            layout[layout_arg.to_s][p.to_s]     # param specified in layout
          else
            defaults[p]                         # layout specified, but not this param
          end
        end
      end

      # Do singleton expansion on the layout argument as well
      # Treated differently since layout is not always specified
      def prep_layout_args(layout_args, expand_by: 1)
        unless layout_args.respond_to?(:each)
          layout_args = [layout_args] * expand_by
        end
        layout_args || []
      end

      # For each parameter/attribute foo we try to invoke a validate_foo
      def validate
        self.class.parameters.each do |param, default|
          method = "validate_#{param}"
          if self.respond_to? method
            attribute = "@#{param}"
            val = instance_variable_get(attribute)
            if val.respond_to? :each
              new_val =  val.map.with_index{ |v, i| send(method, v, i) }
              instance_variable_set(attribute, new_val)
            else
              instance_variable_set(attribute,send(method, val))
            end
          end
        end
      end

      # Access an individual arg for a given card
      # @return an OpenStruct that looks just like the mixed-in class
      # @api private
      def [](i)
        card_arg = OpenStruct.new
        self.class.expanding_parameters.each do |p|
          p_val = instance_variable_get("@#{p}")
          card_arg[p] = p_val[i]
        end
        card_arg
      end

      # Convert units
      def convert_units(dpi: 300)
        self.class.params_with_units.each do |p|
          p_str = "@#{p}"
          p_val = instance_variable_get(p_str)
          if p_val.respond_to? :each
            arr = p_val.map { |x| convert_unit(x, dpi) }
            instance_variable_set p_str, arr
          else
            instance_variable_set p_str, convert_unit(p_val, dpi)
          end
        end
        self
      end

      def convert_unit(arg, dpi)
        case arg.to_s.rstrip
        when /in$/ #ends with "in"
          arg.rstrip[0..-2].to_f * dpi
        when /cm$/ #ends with "cm"
          arg.rstrip[0..-2].to_f * dpi * INCHES_IN_CM
        else
          arg
        end
      end
      module_function :convert_unit

    end

  end
end
