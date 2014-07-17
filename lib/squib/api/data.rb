require 'roo'

module Squib
  class Deck

    def csv(file: 'deck.csv', header: true)
      raise 'Not implemented!'
    end

    def xlsx(file: 'deck.xlsx', sheet: 0)
      s = Roo::Excelx.new(file)
      s.default_sheet = s.sheets[sheet]
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

