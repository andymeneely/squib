module Squib
  # @api private
  module Args
    class CardRange
      include Enumerable

      def initialize(input, deck_size: 1)
        @range = validate(input, deck_size)
      end

      # Hook into enumerable by delegating to @range
      def each(&block)
        @range.each { |i| block.call(i) }
      end

      def size
        @range.size
      end

      private
      def validate(input, deck_size)
        input ||= :all # default
        input = 0..(deck_size - 1) if input == :all
        input = (input.to_i)..(input.to_i) if input.respond_to? :to_i
        raise ArgumentError.new("#{input} must be Enumerable (i.e. respond_to :each).") unless input.respond_to? :each
        raise ArgumentError.new("#{input} is outside of deck range of 0..#{deck_size-1}") if (!input.max.nil?) && (input.max > (deck_size - 1))
        input
      end

    end
  end
end
