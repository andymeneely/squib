require_relative '../args/import'
require_relative '../import/yaml_importer'
require_relative '../errors_warnings/warn_unexpected_params'

module Squib
  # DSL method. See http://squib.readthedocs.io
  def yaml(opts = {}, &block)
    DSL::Yaml.new(__callee__).run(opts, &block)
  end
  module_function :yaml

  class Deck
    # DSL method. See http://squib.readthedocs.io
    def yaml(opts = {}, &block)
      DSL::Yaml.new(__callee__).run(opts, &block)
    end
  end

  module DSL
    class Yaml
      include WarnUnexpectedParams
      attr_reader :dsl_method, :block

      def initialize(dsl_method)
        @dsl_method = dsl_method
      end

      def self.accepted_params
        %i( file data explode )
      end

      def run(opts,&block)
        warn_if_unexpected opts
        import_args = Args.extract_import opts
        importer = Squib::Import::YamlImporter.new
        importer.import_to_dataframe(import_args, &block)
      end
    end
  end
end
