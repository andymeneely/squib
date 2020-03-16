require 'csv'

module Squib::Args
  class CSV_Opts

    def initialize(opts)
      opts = opts.keep_if { |k, _v| CSV::DEFAULT_OPTIONS.key? k}
      @hash = CSV::DEFAULT_OPTIONS.merge(opts).merge(required)
    end

    def to_hash
      @hash
    end

    private

    def required
      { headers: true, converters: :numeric }
    end

  end
end
