require 'rainbow/refinement'

module Squib::WarnUnexpectedParams
  using Rainbow # we can colorize strings now!

  def warn_if_unexpected(opts, uplevel: 5)
    accepted_params = self.class.accepted_params
    unexpected = opts.keys - accepted_params
    unexpected.each do |key|
      warn "Unexpected parameter '#{key.to_s.yellow}:' to #{dsl_method.to_s.cyan}(). Accepted parameters: #{accepted_params}",
           uplevel: uplevel
    end
  end
end
