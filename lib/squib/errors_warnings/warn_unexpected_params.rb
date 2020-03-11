require_relative 'error_context'
require 'rainbow/refinement'

module Squib::WarnUnexpectedParam
  using Rainbow # we can colorize strings now!
  def warn_unexpected_params(opts)
    unexpected = opts.keys - accepted_params
    unexpected.each do |key|
      Squib.logger.warn do
        "Unexpected option '#{key.to_s.yellow}' #{@error_cxt} ...ignoring"
      end
    end
  end
end
