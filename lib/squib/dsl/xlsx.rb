# typed: false
require_relative '../args/import'
require_relative '../import/xlsx_importer'
require_relative '../errors_warnings/warn_unexpected_params'

module Squib
  # DSL method. See http://squib.readthedocs.io
  def xlsx(opts = {}, &block)
    DSL::Xlsx.new(__callee__).run(opts, &block)
  end
  module_function :xlsx

  class Deck
    # DSL method. See http://squib.readthedocs.io
    def xlsx(opts = {}, &block)
      DSL::Xlsx.new(__callee__).run(opts, &block)
    end
  end

  module DSL
    class Xlsx
      include WarnUnexpectedParams
      attr_reader :dsl_method, :block

      def initialize(dsl_method)
        @dsl_method = dsl_method
      end

      def self.accepted_params
        %i( file sheet strip explode )
      end

      def run(opts,&block)
        warn_if_unexpected opts
        import_args = Args.extract_import opts
        importer = Squib::Import::XlsxImporter.new
        importer.import_to_dataframe(import_args, &block)
      end
    end
  end
end
