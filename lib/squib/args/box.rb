require_relative 'arg_loader'
require_relative 'xywh_shorthands'

module Squib::Args

  module_function def extract_box(opts, deck, dsl_method_defaults = {})
    Box.new(deck, dsl_method_defaults).extract!(opts, deck)
  end

  class Box
    include ArgLoader
    include XYWHShorthands

    def initialize(deck = nil, dsl_method_defaults = {})
      @deck = deck
      @dsl_method_defaults = dsl_method_defaults
    end

    def self.parameters
      { x: 0, y: 0,
        width: :deck, height: :deck,
        radius: nil, x_radius: 0, y_radius: 0
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

    def validate_width(arg, _i)
      return arg if @deck.nil?
      apply_shorthands(arg, @deck, axis: :x)
    end

    def validate_height(arg, _i)
      return arg if @deck.nil?
      apply_shorthands(arg, @deck, axis: :y)
    end

    def validate_x_radius(arg, i)
      return radius[i] unless radius[i].nil?
      arg
    end

    def validate_y_radius(arg, i)
      return radius[i] unless radius[i].nil?
      arg
    end   

  end

end
