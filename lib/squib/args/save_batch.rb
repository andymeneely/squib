require_relative 'arg_loader'
require_relative 'dir_validator'

module Squib::Args
  module_function def extract_save_batch(opts, deck)
    SaveBatch.new.extract! opts, deck
  end

  class SaveBatch
    include ArgLoader
    include DirValidator

    def initialize
    end

    def self.parameters
      {
        angle: 0,
        count_format: '%02d',
        dir: '_output',
        prefix: 'card_',
        rotate: false,
        suffix: '',
        trim_radius: 0,
        trim: 0,
      }
    end

    def self.expanding_parameters
      self.parameters.keys # all of them
    end

    def self.params_with_units
      [:trim, :trim_radius]
    end

    def validate_dir(arg, _i)
      ensure_dir_created(arg)
    end

    def validate_rotate(arg, i)
      case arg
      when true, :clockwise
        angle[i] = 0.5 * Math::PI
        return true
      when :counterclockwise
        angle[i] = 1.5 * Math::PI
        return true
      when false
        false
      else
        raise 'invalid option to rotate: only [true, false, :clockwise, :counterclockwise]'
      end
    end

    def full_filename(i)
      "#{dir[i]}/#{prefix[i]}#{count_format[i] % i}#{suffix[i]}.png"
    end

    def summary
      "#{dir[0]}/#{prefix[0]}_*#{suffix[0]}"
    end

  end
end
