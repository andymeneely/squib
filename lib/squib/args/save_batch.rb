require 'squib/args/arg_loader'

module Squib
  # @api private
  module Args
    class SaveBatch
      include ArgLoader

      def initialize #TODO DSL method default for prefix
      end

      def self.parameters
        { dir: '_output',
          prefix: 'card_',
          count_format: '%02d',
          rotate: false,
        }
      end

      def self.expanding_parameters
        [] # none of them
      end

      def self.params_with_units
        [] # none of them
      end

    end
  end
end
