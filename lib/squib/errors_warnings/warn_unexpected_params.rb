require_relative 'caller_finder'

module Squib::WarnUnexpectedParam
  def warn_unexpected_params(opts)
    unexpected = opts.keys - accepted_params
    unexpected.each do |key|
      Squib.logger.warn do
        "Unexpected option '#{key}' #{@error_cxt} ...ignoring"
      end
    end
  end
end
