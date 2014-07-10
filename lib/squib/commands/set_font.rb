module Squib
	module Commands
		
		class SetFont < Command
			include Visitable
			attr_accessor :type, :size, :options

			def initialize(type, size, options)
				@type = type
				@size = size
				#no options yet
			end

		end

	end	
end