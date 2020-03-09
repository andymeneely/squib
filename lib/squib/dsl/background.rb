require_relative '../errors_warnings/warn_unexpected_params'
module Squib
  class Deck
    def background(opts = {}) # DSL method. See http://squib.readthedocs.io
      BackgroundDSLMethod.new(self).run(opts)
    end
  end

  class BackgroundDSLMethod
    include WarnUnexpectedParam

    def initialize(deck)
      @error_cxt = <<~EOS.split("\n").join(' ').strip
        to Squib method '#{caller_locations[1].label}'
        from #{caller_locations[2].path}:#{caller_locations[2].lineno}
      EOS
      @deck = deck
    end

    def accepted_params
      [
        :range,
        :color
      ]
    end


    def run(opts)
      warn_unexpected_params(opts)
      range = Args::CardRange.new(opts[:range], deck_size: @deck.size)
      draw  = Args::Draw.new(@deck.custom_colors).load!(opts, expand_by: @deck.size, layout: @deck.layout, dpi: @deck.dpi)
      range.each { |i| @deck.cards[i].background(draw.color[i]) }
    end
  end
end
