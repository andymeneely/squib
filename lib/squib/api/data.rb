require 'roo'
require 'csv'
require 'squib/args/input_file'

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
    input = Args::InputFile.new(file: 'deck.xlsx').load!(opts)
    s = Roo::Excelx.new(input.file[0])
    s.default_sheet = s.sheets[input.sheet[0]]
    data = {}
    s.first_column.upto(s.last_column) do |col|
      header = s.cell(s.first_row,col).to_s
      data[header] = []
      (s.first_row + 1).upto(s.last_row) do |row|
        cell = s.cell(row,col)
        # Roo hack for avoiding unnecessary .0's on whole integers (https://github.com/roo-rb/roo/issues/139)
        cell = s.excelx_value(row,col) if s.excelx_type(row,col) == [:numeric_or_formula, 'General']
        data[header] << cell
      end#row
    end#col
    data
  end#xlsx
  module_function :xlsx

  # Pulls CSV data from `.csv` files into a column-based hash
  #
  # Pulls the data into a Hash of arrays based on the columns. First row is assumed to be the header row.
  # See the example `samples/csv.rb` in the [source repository](https://github.com/andymeneely/squib/tree/master/samples)
  #
  # @example
  #   # File data.csv looks like this (without the comment symbols)
  #   # h1,h2
  #   # 1,2
  #   # 3,4
  #   data = csv file: 'data.csv'
  #   => {'h1' => [1,3], 'h2' => [2,4]}
  #
  # Parsing uses Ruby's CSV, with options `{headers: true, converters: :numeric}`
  # http://www.ruby-doc.org/stdlib-2.0/libdoc/csv/rdoc/CSV.html
  #
  # @option opts file [String]  the CSV-formatted file to open. Opens relative to the current directory.
  # @return [Hash] a hash of arrays based on columns in the table
  # @api public
  def csv(opts = {})
    file = Args::InputFile.new(file: 'deck.csv').load!(opts).file[0]
    opts = Squib::SYSTEM_DEFAULTS.merge(opts)
    # opts = Squib::InputHelpers.fileify(opts)
    table = CSV.read(file, headers: true, converters: :numeric)
    check_duplicate_csv_headers(table)
    hash = Hash.new
    table.headers.each do |header|
      hash[header.to_s] ||= table[header]
    end
    return hash
  end
  module_function :csv

  # Check if the given CSV table has duplicate columns, and throw a warning
  # @api private
  def check_duplicate_csv_headers(table)
    if table.headers.size != table.headers.uniq.size
      dups = table.headers.select{|e| table.headers.count(e) > 1 }
      Squib.logger.warn "CSV duplicated the following column keys: #{dups.join(',')}"
    end
  end
  module_function :check_duplicate_csv_headers

  class Deck

    # Convenience call on deck goes to the module function
    def xlsx(opts = {})
      Squib.xlsx(opts)
    end

    # Convenience call on deck goes to the module function
    def csv(opts = {})
      Squib.csv(opts)
    end

  end
end
