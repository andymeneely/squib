require_relative 'arg_loader'
require_relative 'xywh_shorthands'

module Squib::Args
  module_function def extract_scale_box(opts, deck)
    ScaleBox.new.extract!(opts, deck)
  end

  class ScaleBox
    include ArgLoader
    include XYWHShorthands

    def self.parameters
      {
        x: 0, y: 0,
        width: :native, height: :native
      }
    end

    def self.expanding_parameters
      parameters.keys # all of them
    end

    def self.params_with_units
      parameters.keys # all of them
    end

    def validate_x(arg, i) apply_shorthands(arg, @deck, axis: :x) end
    def validate_y(arg,_i) apply_shorthands(arg, @deck, axis: :y) end

    def validate_width(arg, i)
      return @deck.width if arg.to_s == 'deck'
      return :native     if arg.to_s == 'native'
      arg = apply_shorthands(arg, @deck, axis: :x)
      return arg         if arg.respond_to? :to_f
      if arg.to_s == 'scale'
        raise 'if width is :scale, height must be a number' unless height[i].respond_to? :to_f
        return arg
      end
      raise 'width must be a number, :scale, :native, or :deck'
    end

    def validate_height(arg, i)
      return @deck.height if arg.to_s == 'deck'
      return :native      if arg.to_s == 'native'
      arg = apply_shorthands(arg, @deck, axis: :y)
      return arg          if arg.respond_to? :to_f
      if arg.to_s == 'scale'
        raise 'if height is \'scale\', width must be a number' unless width[i].respond_to? :to_f
        return arg
      end
      raise 'height must be a number, :scale, :native, or :deck'
    end

  end

end
