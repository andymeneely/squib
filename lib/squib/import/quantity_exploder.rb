module Squib
  module Import
    module QuantityExploder
      def explode_quantities(data, qty)
        return data unless data.col? qty.to_s.strip
        qtys = data[qty]
        new_data = Squib::DataFrame.new
        data.each do |col, arr|
          new_data[col] = []
          qtys.each_with_index do |qty, index|
            qty.to_i.times { new_data[col] << arr[index] }
          end
        end
        return new_data
      end
    end
  end
end