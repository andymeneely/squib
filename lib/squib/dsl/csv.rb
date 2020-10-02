require_relative '../args/import'
require_relative '../args/csv_opts'
require_relative '../import/csv_importer'
require_relative '../errors_warnings/warn_unexpected_params'

module Squib
  # DSL method. See http://squib.readthedocs.io
  def csv(opts = {}, &block)
    DSL::Csv.new(__callee__).run(opts, &block)
  end
  module_function :csv

  class Deck
    # DSL method. See http://squib.readthedocs.io
    def csv(opts = {}, &block)
      DSL::Csv.new(__callee__).run(opts, &block)
    end
  end

  module DSL
    class Csv
      include WarnUnexpectedParams
      attr_reader :dsl_method, :block

      def initialize(dsl_method)
        @dsl_method = dsl_method
      end

      def self.accepted_params
        %i( file data strip explode col_sep quote_char)
      end

      def run(opts,&block)
        warn_if_unexpected opts
        import_args = Args.extract_import opts
        importer = Squib::Import::CsvImporter.new
        csv_opts = Args::CSV_Opts.new(opts)
        importer.import_to_dataframe(import_args, csv_opts, &block)
      end
    end
  end
end
