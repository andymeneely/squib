module Squib
  class Margin
    attr_reader :top
    attr_reader :right
    attr_reader :bottom
    attr_reader :left

    ##
    # Create a new margin definition.
    #
    # Takes +definition+ which can either be a space-separated +String+ or an
    # +Array+ of +Float+ and will translate it to the top, right, bottom and
    # left members.
    #
    # The syntax follows how CSS parses margin shorthand strings.
    def initialize(definition)
      if definition.instance_of? String
        @top, @right, @bottom, @left = expand_shorthand(
          definition.split(/\s+/).map!(&:to_f))
      elsif definition.is_a? Numeric
        @top, @right, @bottom, @left = expand_shorthand [definition]
      elsif definition.instance_of? Array
        @top, @right, @bottom, @left = expand_shorthand definition
      else
        raise ArgumentError, 'Invalid value, must be either string or array'
      end
    end

    ##
    # Map out the margin array.
    #
    # Takes +margin_arr+ and attempt to expand it to a strict [top, right,
    # bottom, left] array.
    private def expand_shorthand(margin_arr)
      if margin_arr.size == 1
        all = margin_arr[0]
        [all, all, all, all]
      elsif margin_arr.size == 2
        margin_arr + margin_arr
      elsif margin_arr.size == 3
        margin_arr + [margin_arr[1]]
      elsif margin_arr.size >= 4
        margin_arr[0..3]
      else
        raise ArgumentError, 'Invalid array'
      end
    end
  end


  class Gap
    attr_reader :horizontal
    attr_reader :vertical

    def initialize(definition)
      if definition.instance_of? String
        @horizontal, @vertical = expand_shorthand(
          definition.split(/\s+/).map!(&:to_f))
      elsif definition.instance_of? Array
        @horizontal, @vertical = expand_shorthand definition
      elsif definition.is_a? Numeric
        @horizontal, @vertical = definition, definition
      else
        raise ArgumentError, 'Invalid value, must be either string or array'
      end
    end

    private def expand_shorthand(gap_arr)
      if gap_arr.size >= 2
        gap_arr[0..1]
      elsif gap_arr.size == 1
        gap_arr + gap_arr
      else
        raise ArgumentError, 'Invalid array'
      end
    end
  end


  class TemplateOption
    attr_accessor :unit
    attr_accessor :sheet_width
    attr_accessor :sheet_height
    attr_writer :sheet_margin
    attr_accessor :sheet_align
    attr_accessor :card_width
    attr_accessor :card_height
    attr_writer :card_gap
    attr_accessor :card_ordering
    attr_accessor :output_file
    attr_accessor :crop_lines

    def sheet_margin
      if not @sheet_margin.instance_of? Margin
        @sheet_margin = Margin.new @sheet_margin
      else
        @sheet_margin
      end
    end

    def card_gap
      if not @card_gap.instance_of? Gap
        @card_gap = Gap.new @card_gap
      else
        @card_gap
      end
    end
  end
end
