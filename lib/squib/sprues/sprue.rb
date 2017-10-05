require 'yaml'
require 'classy_hash'
require_relative '../args/color_validator'
require_relative '../args/unit_conversion'
require_relative 'crop_line'
require_relative 'crop_line_dash'
require_relative 'invalid_sprue_definition'
require_relative 'sprue_schema'

module Squib
  class Sprue
    include Args::ColorValidator

    # Defaults are set for poker sized deck on a A4 sheet, with no cards
    DEFAULTS = {
      'sheet_width' => nil,
      'sheet_height' => nil,
      'card_width' => nil,
      'card_height' => nil,
      'dpi' => 300,
      'position_reference' => :topleft,
      'rotate' => 0.0,
      'crop_line' => {
        'style' => :solid,
        'width' => '0.02mm',
        'color' => :black,
        'overlay' => :on_margin,
        'lines' => []
      },
      'cards' => []
    }.freeze

    attr_reader :dpi

    def initialize(template_hash, dpi)
      @template_hash = template_hash
      @dpi = dpi
      @crop_line_default = @template_hash['crop_line'].select do |k, _|
        %w[style width color].include? k
      end
    end

    # Load the template definition file
    def self.load(file, dpi)
      yaml = {}
      thefile = file if File.exist?(file) # use custom first
      thefile = builtin(file) if File.exist?(builtin(file)) # then builtin
      unless File.exist?(thefile)
        Squib::logger.error("Sprue not found: #{file}. Falling back to defaults.")
      end
      yaml = YAML.load_file(thefile) || {} if File.exist? thefile
      # Bake the default values into our sprue
      new_hash = DEFAULTS.merge(yaml)
      new_hash['crop_line'] = DEFAULTS['crop_line'].
                                merge(new_hash['crop_line'])
      warn_unrecognized(yaml)

      # Validate
      begin
        require 'benchmark'
        ClassyHash.validate(new_hash, Sprues::SCHEMA)
      rescue ClassyHash::SchemaViolationError => e
        raise Sprues::InvalidSprueDefinition.new(thefile, e)
      end
      Sprue.new new_hash, dpi
    end

    def sheet_width
      Args::UnitConversion.parse @template_hash['sheet_width'], @dpi
    end

    def sheet_height
      Args::UnitConversion.parse @template_hash['sheet_height'], @dpi
    end

    def card_width
      Args::UnitConversion.parse @template_hash['card_width'], @dpi
    end

    def card_height
      Args::UnitConversion.parse @template_hash['card_height'], @dpi
    end

    def card_default_rotation
      parse_rotate_param @template_hash['rotate']
    end

    def crop_line_overlay
      @template_hash['crop_line']['overlay']
    end

    def crop_lines
      lines = @template_hash['crop_line']['lines'].map(
        &method(:parse_crop_line)
      )
      if block_given?
        lines.each { |v| yield v }
      else
        lines
      end
    end

    def cards
      parsed_cards = @template_hash['cards'].map(&method(:parse_card))
      if block_given?
        parsed_cards.each { |v| yield v }
      else
        parsed_cards
      end
    end

    def margin
      # NOTE: There's a baseline of 0.25mm that we can 100% make sure that we
      # can overlap really thin lines on the PDF
      crop_line_width = [
        Args::UnitConversion.parse(@template_hash['crop_line']['width'], @dpi),
        Args::UnitConversion.parse('0.25mm', @dpi)
      ].max

      parsed_cards = cards
      left, right = parsed_cards.minmax { |a, b| a['x'] <=> b['x'] }
      top, bottom = parsed_cards.minmax { |a, b| a['y'] <=> b['y'] }

      {
        left: left['x'] - crop_line_width,
        right: right['x'] + card_width + crop_line_width,
        top: top['y'] - crop_line_width,
        bottom: bottom['y'] + card_height + crop_line_width
      }
    end

    # Warn unrecognized options in the template sheet
    def self.warn_unrecognized(yaml)
      unrec = yaml.keys - DEFAULTS.keys
      return unless unrec.any?

      Squib.logger.warn(
        "Unrecognized configuration option(s): #{unrec.join(',')}"
      )
    end

    private

    # Return path for built-in sheet templates
    def self.builtin(file)
      "#{File.dirname(__FILE__)}/../builtin/sprues/#{file}"
    end

    # Parse crop line definitions from template.
    def parse_crop_line(line)
      new_line = @crop_line_default.merge line
      new_line['width'] = Args::UnitConversion.parse(new_line['width'], @dpi)
      new_line['color'] = colorify new_line['color']
      new_line['style_desc'] = new_line['style']
      new_line['style'] = Sprues::CropLineDash.new(new_line['style'], @dpi)
      new_line['line'] = Sprues::CropLine.new(
        new_line['type'], new_line['position'], sheet_width, sheet_height, @dpi
      )
      new_line
    end

    # Parse card definitions from template.
    def parse_card(card)
      new_card = card.clone

      x = Args::UnitConversion.parse(card['x'], @dpi)
      y = Args::UnitConversion.parse(card['y'], @dpi)
      if @template_hash['position_reference'] == :center
        # Normalize it to a top-left positional reference
        x -= card_width / 2
        y -= card_height / 2
      end

      new_card['x'] = x
      new_card['y'] = y
      new_card['rotate'] = parse_rotate_param(
        card['rotate'] ? card['rotate'] : @template_hash['rotate'])
      new_card
    end

    def parse_rotate_param(val)
      if val == :clockwise
        0.5 * Math::PI
      elsif val == :counterclockwise
        1.5 * Math::PI
      elsif val == :turnaround
        Math::PI
      elsif val.is_a? String
        if val.end_with? 'deg'
          val.gsub(/deg$/, '').to_f / 180 * Math::PI
        elsif val.end_with? 'rad'
          val.gsub(/rad$/, '').to_f
        else
          val.to_f
        end
      elsif val.nil?
        0.0
      else
        val.to_f
      end
    end
  end
end
