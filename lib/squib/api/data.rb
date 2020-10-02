require 'roo'
require 'csv'
require 'yaml'
require_relative '../args/input_file'
require_relative '../args/import'
require_relative '../args/csv_opts'
require_relative '../import/data_frame'

module Squib

  # DSL method. See http://squib.readthedocs.io
  def csv(opts = {})
    # TODO refactor all this out to separate methods, and its own class
    import = Args::Import.new.load!(opts)
    file = Args::InputFile.new(file: 'deck.csv').load!(opts).file[0]
    data = opts.key?(:data) ? opts[:data] : File.read(file)
    csv_opts = Args::CSV_Opts.new(opts)
    table = CSV.parse(data, **csv_opts.to_hash)
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

  # DSL method. See http://squib.readthedocs.io
  def yaml(opts = {})
    input = Args::InputFile.new(file: 'deck.yml').load!(opts)
    import = Args::Import.new.load!(opts)
    yml = YAML.load_file(input.file[0])
    data = Squib::DataFrame.new
    # Get a universal list of keys to ensure everything is covered.
    keys = yml.map { |c| c.keys}.flatten.uniq
    keys.each { |k| data[k] = [] } #init arrays
    yml.each do |card|
      # nil value if key isn't set.
      keys.each { |k| data[k] << card[k] }
    end
    if block_given?
      data.each do |header, col|
        col.map! do |val|
          yield(header, val)
        end
      end
    end
    explode_quantities(data, import.explode)
  end
  module_function :yaml

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

    # DSL method. See http://squib.readthedocs.io
    def xlsx(opts = {})
      Squib.xlsx(opts)
    end

    # DSL method. See http://squib.readthedocs.io
    def csv(opts = {})
      Squib.csv(opts)
    end

    # DSL method. See http://squib.readthedocs.io
    def yaml(opts = {})
      Squib.yaml(opts)
    end
  end
end
