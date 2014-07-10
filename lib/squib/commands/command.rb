module Squib
  module Commands

    module Visitable
      def accept visitor
        visitor.visit self
      end
    end

    class Command
      def accept visitor
        raise NotImpelementedError.new
      end
    end

  end
end