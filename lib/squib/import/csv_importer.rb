require 'csv'
require_relative 'quantity_exploder'

module Squib::Import
  class CsvImporter
    include Squib::Import::QuantityExploder
    def import_to_dataframe(import, csv_opts, &block)
      data = import.data.nil? ? File.read(import.file) : import.data
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
      unless block.nil?
        hash.each do |header, col|
          col.map! do |val|
            yield(header, val)
          end
        end
      end
      return explode_quantities(hash, import.explode)
    end

    def check_duplicate_csv_headers(table)
      if table.headers.size != table.headers.uniq.size
        dups = table.headers.select{|e| table.headers.count(e) > 1 }
        Squib.logger.warn "CSV duplicated the following column keys: #{dups.join(',')}"
      end
    end
  end
end

