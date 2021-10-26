autoload :Roo, 'roo'
require_relative 'quantity_exploder'

module Squib::Import
  class XlsxImporter
    include Squib::Import::QuantityExploder
    def import_to_dataframe(import, &block)
      s = Roo::Excelx.new(import.file)
      s.default_sheet = s.sheets[import.sheet]
      data = Squib::DataFrame.new
      s.first_column.upto(s.last_column) do |col|
        header = s.cell(s.first_row, col).to_s
        header = header.strip if import.strip?
        data[header] = []
        (s.first_row + 1).upto(s.last_row) do |row|
          cell = s.cell(row, col)
          # Roo hack for avoiding unnecessary .0's on whole integers (https://github.com/roo-rb/roo/issues/139)
          cell = s.excelx_value(row, col) if s.excelx_type(row, col) == [:numeric_or_formula, 'General']
          cell = cell.strip if cell.respond_to?(:strip) && import.strip?
          cell = block.yield(header, cell) unless block.nil?
          data[header] << cell
        end# row
      end# col
      explode_quantities(data, import.explode)
    end
  end
end

