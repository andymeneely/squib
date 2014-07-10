module Squib
  module Commands
    
    class Font < Command
      include Visitable
      attr_accessor :type, :size

      def initialize(type,size, options)
        @type = type
        @size = size
        #no other options yet
      end

    end
  
  end
end