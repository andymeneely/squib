require 'cairo'

module Squib
  # @api private
  module Args

    class HandSpecial
      include ArgLoader

      def initialize(card_height)
        @card_height = card_height
      end

      def self.parameters
        {
          angle_range: (Math::PI / -4.0)..(Math::PI / 4),
          radius: :auto
        }
      end

      def self.expanding_parameters
        [] # none of them
      end

      def self.params_with_units
        [ :radius ]
      end

      def validate_radius(arg)
        return 0.3 * @card_height if arg.to_s.downcase.strip == 'auto'
        arg
      end

    end

  end
end
