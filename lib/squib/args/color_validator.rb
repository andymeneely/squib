module Squib
  #@api private
  module Args
    module ColorValidator

      def colorify(color, custom_colors = {})
        custom_colors[color.to_s] || color.to_s
      end

    end
  end
end