require 'squib/args/arg_loader'

module Squib
  # @api private
  module Args

    class Paragraph
      include ArgLoader

      def self.parameters
        { align: :left,
          str: 'Hello, World!',
          font: :use_set,
          font_size: nil,
          markup: false,
          justify: false,
          wrap: true,
          ellipsize: :end,
          spacing: 0,
          valign: :top,
          hint: :off
        }
      end

      def self.expanding_parameters
        parameters.keys # all of them
      end

      def self.params_with_units
        [] # none of them
      end

      def validate_str(arg, _i)
        arg.to_s
      end

    end

  end
end