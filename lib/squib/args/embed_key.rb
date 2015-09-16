require 'squib/args/arg_loader'

module Squib
  # @api private
  module Args

    class EmbedKey

      # Validate the embed lookup key
      def validate_key(str)
        str.to_s
      end

    end

  end
end
