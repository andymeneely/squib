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
        @dpi = dpi
        set_attributes(args: args)
        expand(by: expand_by)
        layout_args = prep_layout_args(args[:layout], expand_by: expand_by)
        defaultify(layout_args: layout_args || [], layout: layout)
        validate
        convert_units
        self
      end

      # Iterate over the args hash and create instance-level attributes for
      # each parameter
      # Assumes we have a hash of parameters to their default keys in the class
      def set_attributes(args: args)
        attributes = self.class.parameters.keys
        attributes.each do |p|
          instance_variable_set "@#{p}", args[p] # often nil, but ok
        end
        self.class.class_eval { attr_reader *(attributes) }
      end

       # Conduct singleton expansion
       # If expanding-parameter is not already responding to
       # :each then copy it into an array
       #
       # Assumes we have an self.expanding_parameters
      def expand(by: 1)
        exp_params = self.class.expanding_parameters
        exp_params.each do |p|
          attribute = "@#{p}"
          arg = instance_variable_get(attribute)
          unless arg.respond_to? :each
            instance_variable_set attribute, [arg] * by #expand singleton
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

      # Go over each argument and fill it in with layout and defaults wherever nil
      def defaultify(layout_args: [], layout: {})
        self.class.parameters.each do |param, default|
          attribute = "@#{param}"
          val = instance_variable_get(attribute)
          if val.respond_to? :each
            new_val = val.map.with_index do |v, i|
              v ||= layout[layout_args[i]][param] unless layout_args[i].nil?
              v ||= default
            end
            instance_variable_set(attribute, new_val)
          else # a non-expanded singleton
            # TODO handle this case
          end
        end
      end

      # For each parameter/attribute foo we try to invoke a validate_foo
      def validate
        self.class.parameters.each do |param, default|
          method    = "validate_#{param}"
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