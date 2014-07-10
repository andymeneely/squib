module Squib
  module Visitors

    class VerifyVistior < BaseVisitor
      def visit_Font 
        puts "Verify Font!!"
      end

      def visit_SetFont
        puts "Verify SetFont!!"
      end
    end

  end
end