module Squib::Args
  module_function def extract_import(opts)
    # note how we don't use ArgLoader here because it's way more complex than
    # what we need here. Don't need layouts or singleton expansion, so...
    # ...let's just do it ourselves.
    Import.parameters.each  { |p, value| opts[p] = value unless opts.key? p }
    return Import.new.load! opts
  end

  class Import
    
    def self.parameters
      { strip: true,
        explode: 'qty',
        file: nil,
        sheet: 0
      }
    end

    attr_accessor *(self.parameters.keys)

    def self.expanding_parameters
      [] # none of them
    end

    def self.params_with_units
      [] # none of them
    end

    def load!(opts)
      @strip   = validate_strip   opts[:strip]
      @explode = validate_explode opts[:explode]
      @file    = validate_file    opts[:file]
      @sheet   = opts[:sheet]
      return self
    end

    def validate_strip(arg)
      raise 'Strip must be true or false' unless arg == true || arg == false
      arg
    end

    def validate_explode(arg)
      arg.to_s
    end

    def validate_file(arg)
      raise 'file argument not provided.' if arg.nil?
      raise "File #{File.expand_path(arg)} does not exist!" unless File.exists?(arg)
      File.expand_path(arg)
    end

    def strip?
      strip
    end

  end

end
