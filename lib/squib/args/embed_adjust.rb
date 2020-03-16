require_relative 'arg_loader'

module Squib::Args

  class EmbedAdjust
    include ArgLoader

    def self.parameters
      { dx: 0, dy: 0 }
    end

    def self.expanding_parameters
      parameters.keys # all of them
    end

    def self.params_with_units
      parameters.keys # all of them
    end

  end

end
