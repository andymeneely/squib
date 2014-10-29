require 'roo'

module Squib

  # Pulls Excel data from `.xlsx` files into a column-based hash
  #
  # Pulls the data into a Hash of arrays based on the columns. First row is assumed to be the header row.
  # See the example `samples/excel.rb` in the [source repository](https://github.com/andymeneely/squib/tree/master/samples)
  #
  # @example
  #   # Excel file looks like this:
  #   # | h1 | h2 |
  #   # ------------
  #   # | 1  | 2  |
  #   # | 3  | 4  |
  #   data = xlsx file: 'data.xlsx', sheet: 0
  #   {'h1' => [1,3], 'h2' => [2,4]}
  #
  # @option opts file [String]  the file to open. Must end in `.xlsx`. Opens relative to the current directory.
  # @option opts sheet [Integer] (0) The zero-based index of the sheet from which to read.
  # @return [Hash] a hash of arrays based on columns in the spreadsheet
  # @api public
  def xlsx(opts = {})
    opts = Squib::SYSTEM_DEFAULTS.merge(opts)
    opts = Squib::InputHelpers.fileify(opts)
    s = Roo::Excelx.new(opts[:file])
    s.default_sheet = s.sheets[opts[:sheet]]
    data = {}
    s.first_column.upto(s.last_column) do |col|
      header = s.cell(s.first_row,col).to_s
      data[header] = []
      (s.first_row+1).upto(s.last_row) do |row|
        cell = s.cell(row,col)
        # Roo hack for avoiding unnecessary .0's on whole integers
        cell = s.excelx_value(row,col) if s.excelx_type(row,col) == [:numeric_or_formula, 'General']
        data[header] << cell
      end#row
    end#col
    data
  end#xlsx
  module_function :xlsx

  class Deck

    # Convenience call for Squib.xlsx
    def xlsx(opts = {})
      Squib.xlsx(opts)
    end

  end
end

