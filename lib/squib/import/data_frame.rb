# encoding: UTF-8

require 'json'
require 'forwardable'

module Squib
  class DataFrame
    include Enumerable

    def initialize(hash = {}, def_columns = true)
      @hash = hash
      columns.each { |col| def_column(col) } if def_columns
    end

    def each(&block)
      @hash.each(&block)
    end

    def [](i)
      @hash[i]
    end

    def []=(col, v)
      @hash[col] = v
      def_column(col)
      return v
    end

    def columns
      @hash.keys
    end

    def ncolumns
      @hash.keys.size
    end

    def col?(col)
      @hash.key? col
    end

    def row(i)
      @hash.inject(Hash.new) { |ret, (name, arr)| ret[name] = arr[i]; ret }
    end

    def nrows
      @hash.inject(0) { |max, (_n, col)| col.size > max ? col.size : max }
    end

    def to_json
      @hash.to_json
    end

    def to_pretty_json
      JSON.pretty_generate(@hash)
    end

    def to_h
      @hash
    end

    def to_pretty_text
      max_col = columns.inject(0) { |max, c | c.length > max ? c.length : max }
      top    = " ╭#{'-' * 36}╮\n"
      bottom = " ╰#{'-' * 36}╯\n"
      str =  ''
      0.upto(nrows - 1) do | i |
        str += (' ' * max_col) + top
        row(i).each do |col, data|
          str += "#{col.rjust(max_col)} #{wrap_n_pad(data, max_col)}"
        end
        str += (' ' * max_col) + bottom
      end
      return str
    end

    private

    def snake_case(str)
      str.to_s.
          strip.
          gsub(/\s+/,'_').
          gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
          gsub(/([a-z]+)([A-Z])/,'\1_\2').
          downcase.
          to_sym
    end

    def wrap_n_pad(str, max_col)
      new_str = str.to_s + ' ' # handle nil & empty strings
      new_str = new_str.
                  scan(/.{1,34}/). # break down
                  map { |s| (' ' * max_col) + " | " + s.ljust(34) }.
                  join(" |\n").
                  lstrip      # initially no whitespace next to key
      return new_str + " |\n"
    end

    def def_column(col)
      raise "Column #{col} - does not exist" unless @hash.key? col
      method_name = snake_case(col)
      return if self.class.method_defined?(method_name) #warn people? or skip?
      define_singleton_method method_name do
        @hash[col]
      end
    end

  end
end
