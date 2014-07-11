module Squib
	module Render

		class RenderContext
      attr_accessor :font  #current font we're using
      attr_accessor :cur   #index of the current card rendering
      attr_accessor :cards #total number of cards we're iterating over
		end

	end
end