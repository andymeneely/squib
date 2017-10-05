module Squib
  module Sprues
    class InvalidSprueDefinition < StandardError
      def initialize(file, error)
        super("Invalid sprue definition in file: #{file}. #{error.message}")
      end
    end
  end
end
