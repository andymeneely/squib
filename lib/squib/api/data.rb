require 'roo'
require 'csv'
require_relative '../args/input_file'
require_relative '../args/import'
require_relative '../args/csv_opts'
require_relative '../import/data_frame'

module Squib

  # DSL method. See http://squib.readthedocs.io
  def xlsx(opts = {})
    input = Args::InputFile.new(file: 'deck.xlsx').load!(opts)
    import = Args::Import.new.load!(opts)
    s = Roo::Excelx.new(input.file[0])
    s.default_sheet = s.sheets[input.sheet[0]]
    data = Squib::DataFrame.new
    s.first_column.upto(s.last_column) do |col|
      header = s.cell(s.first_row, col).to_s
      header.strip! if import.strip?
      data[header] = []
      (s.first_row + 1).upto(s.last_row) do |row|
        cell = s.cell(row, col)
        # Roo hack for avoiding unnecessary .0's on whole integers (https://github.com/roo-rb/roo/issues/139)
        cell = s.excelx_value(row, col) if s.excelx_type(row, col) == [:numeric_or_formula, 'General']
        cell.strip! if cell.respond_to?(:strip) && import.strip?
        cell = yield(header, cell) if block_given?
        data[header] << cell
      end# row
    end# col
    explode_quantities(data, import.explode)
  end# xlsx
  module_function :xlsx

  # DSL method. See http://squib.readthedocs.io
  def csv(opts = {})
    # TODO refactor all this out to separate methods, and its own class
    import = Args::Import.new.load!(opts)
    file = Args::InputFile.new(file: 'deck.csv').load!(opts).file[0]
    data = opts.key?(:data) ? opts[:data] : File.read(file)
    csv_opts = Args::CSV_Opts.new(opts)
    table = CSV.parse(data, csv_opts.to_hash)
    check_duplicate_csv_headers(table)
    hash = Squib::DataFrame.new
    table.headers.each do |header|
      new_header = header.to_s
      new_header = new_header.strip if import.strip?
      hash[new_header] ||= table[header]
    end
    if import.strip?
      new_hash = Squib::DataFrame.new
      hash.each do |header, col|
        new_hash[header] = col.map do |str|
          str = str.strip if str.respond_to?(:strip)
          str
        end
      end
      hash = new_hash
    end
    if block_given?
      hash.each do |header, col|
        col.map! do |val|
          yield(header, val)
        end
      end
    end
    return explode_quantities(hash, import.explode)
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

  # @api private
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
  module_function :explode_quantities

  class Deck

    # DSL method. See http://squib.readthedocs.io
    def xlsx(opts = {})
      Squib.xlsx(opts)
    end

    # DSL method. See http://squib.readthedocs.io
    def csv(opts = {})
      Squib.csv(opts)
    end

  end
end
