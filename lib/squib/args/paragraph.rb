require_relative '../constants'
require_relative 'arg_loader'

module Squib
  # @api private
  module Args

    class Paragraph
      include ArgLoader


      def self.parameters
        { align:     :left,
          str:       'Hello, World!',
          font:      :use_set,
          font_size: nil,
          markup:    false,
          justify:   false,
          wrap:      true,
          ellipsize: :end,
          spacing:   nil,
          valign:    :top,
          hint:      :off
        }
      end

      def self.expanding_parameters
        parameters.keys # all of them
      end

      def self.params_with_units
        [] # none of them
      end

      def initialize(deck_font)
        @deck_font = deck_font
      end

      def validate_str(arg, _i)
        arg.to_s
      end

      def validate_font(arg, _i)
        arg = @deck_font if arg == :use_set
        arg = DEFAULT_FONT if arg == :default
        arg
      end

      def validate_align(arg, _i)
        case arg.to_s.downcase.strip
        when 'left'
          Pango::Alignment::LEFT
        when 'right'
          Pango::Alignment::RIGHT
        when 'center'
          Pango::Alignment::CENTER
        else
          raise ArgumentError, 'align must be one of: center, left, right'
        end
      end

      def validate_wrap(arg, _i)
        case arg.to_s.downcase.strip
        when 'word'
          Pango::WrapMode::WORD
        when 'char', 'false'
          Pango::WrapMode::CHAR
        when 'word_char', 'true'
          Pango::WrapMode::WORD_CHAR
        else
          raise ArgumentError, 'wrap must be one of: word, char, word_char, true, or false'
        end
      end

      def validate_ellipsize(arg, _i)
        case arg.to_s.downcase.strip
        when 'none', 'false'
          Pango::EllipsizeMode::NONE
        when 'start'
          Pango::EllipsizeMode::START
        when 'middle'
          Pango::EllipsizeMode::MIDDLE
        when 'end', 'true'
          Pango::EllipsizeMode::END
        else
          raise ArgumentError, 'ellipsize must be one of: none, start, middle, end, true, or false'
        end
      end

      def validate_justify(arg, _i)
        case arg
        when nil, true, false
          arg
        else
          raise ArgumentError, 'justify must be one of: nil, true, or false'
        end
      end

      def validate_spacing(arg, _i)
        return nil if arg.nil?
        raise ArgumentError, 'spacing must be a number or nil' unless arg.respond_to? :to_f
        arg.to_f * Pango::SCALE
      end

      def validate_valign(arg, _i)
        if %w(top middle bottom).include? arg.to_s.downcase
          arg.to_s.downcase
        else
          raise ArgumentError, 'valign must be one of: top, middle, bottom'
        end
      end

    end

  end
end
