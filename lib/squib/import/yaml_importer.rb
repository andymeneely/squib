require 'yaml'
require_relative 'data_frame'
require_relative 'quantity_exploder'

module Squib::Import
  class YamlImporter
    include Squib::Import::QuantityExploder
    def import_to_dataframe(import, &block)
      data = import.data.nil? ? File.read(import.file) : import.data
      yml = YAML.load(data)
      data = Squib::DataFrame.new
      # Get a universal list of keys to ensure everything is covered.
      keys = yml.map { |c| c.keys}.flatten.uniq
      keys.each { |k| data[k] = [] } #init arrays
      yml.each do |card|
      # nil value if key isn't set.
      keys.each { |k| data[k] << card[k] }
      end
      unless block.nil?
        data.each do |header, col|
          col.map! do |val|
          block.yield(header, val)
          end
        end
      end
      explode_quantities(data, import.explode)
    end
  end
end

