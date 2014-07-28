require 'roo'

module Squib
  class Deck

    #@api private todo
    def csv(file: 'deck.csv', header: true)
      raise 'Not implemented!'
    end

    # Convenience method for pulling Excel data from `.xlsx` files
    #   Pulls the data into a Hash of arrays based on the columns. First row is assumed to be the header row. 
    #   See the example at {file:samples/excel.rb samples/excel.rb}. The accompanying Excel file is in the [source repository](https://github.com/andymeneely/squib/tree/master/samples)
    #
    # @param file: [String] the file to open. Must end in `.xlsx`. Opens relative to the current directory.
    # @param sheet: [Integer] The zero-based index of the sheet from which to read.
    # @api public
    def xlsx(opts = {})
      opts = needs(opts, [:file, :sheet])
      s = Roo::Excelx.new(opts[:file])
      s.default_sheet = s.sheets[opts[:sheet]]
      data = {}
      s.first_column.upto(s.last_column) do |col|
        header = s.cell(s.first_row,col).to_s
        data[header] = []
        (s.first_row+1).upto(s.last_row) do |row|
          cell = s.cell(row,col)
          # Roo hack for avoiding unnecessary .0's on whole integers
          cell = s.excelx_value(row,col) if s.excelx_type(row,col) == [:numeric_or_formula, "General"]
          data[header] << cell
        end#row
      end#col
      data
    end#xlsx

  end
end

