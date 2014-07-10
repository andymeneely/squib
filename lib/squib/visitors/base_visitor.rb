module Squib
  module Visitors

    class BaseVisitor
      def visit subject
        method_name = "visit_#{subject.class}".intern
        send(method_name, subject)
      end
    end

  end
end