require 'cairo'
require_relative 'arg_loader'
require_relative 'dir_validator'

module Squib
  # @api private
  module Args

    class ShowcaseSpecial
      include ArgLoader
      include DirValidator

      def self.parameters
        {
          scale: 0.85,
          trim: 0,
          trim_radius: 38,
          offset: 1.1,
          reflect_offset: 15,
          reflect_percent: 0.25,
          reflect_strength: 0.2,
          face: :left,
        }
      end

      def self.expanding_parameters
        [] # none of them
      end

      def self.params_with_units
        [ :reflect_offset ]
      end

      def face_right?
        @face.to_s.strip.downcase == 'right'
      end

    end

  end
end
