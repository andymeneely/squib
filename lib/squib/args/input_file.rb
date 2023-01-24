require_relative 'arg_loader'

module Squib::Args
  module_function def extract_input_file(opts, deck, dsl_method_default = {})
    InputFile.new(dsl_method_default).extract!(opts, deck)
  end

  class InputFile
    include ArgLoader

    def initialize(dsl_method_default = {})
      @dsl_method_default = dsl_method_default
    end

    def self.parameters
      {
        file: nil,
        placeholder: nil
      }
    end

    def self.expanding_parameters
      parameters.keys # all of them
    end

    def self.params_with_units
      [] # none of them
    end

    def validate_file(arg, i)
      return nil if arg.nil?
      return File.expand_path(arg) if File.exist?(arg)
      return File.expand_path(placeholder[i]) if File.exist?(placeholder[i].to_s)

      case deck_conf.img_missing.to_sym
      when :error
        raise "File #{File.expand_path(arg)} does not exist!"
      when :warn
        Squib.logger.warn "File #{File.expand_path(arg)} does not exist!"
      end
      return nil # the silent option - as if nil in the first place
    end

    def validate_placeholder(arg, _i)
      # What if they specify placeholder, but it doesn't exist?
      # ...always warn... that's probably a mistake they made
      unless arg.nil? || File.exist?(arg)
        msg = "Image placeholder #{File.expand_path(arg)} does not exist!"
        Squib.logger.warn msg
        return nil
      end
      return arg
    end
  end
end
