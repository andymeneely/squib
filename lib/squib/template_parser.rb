require "yaml"
require "classy_hash"
require_relative 'args/color_validator'
require_relative 'args/unit_conversion'


module Squib
  class CropLineDash
    VALIDATION_REGEX = %r{
      ^(\d*[.])?\d+(in|cm|mm)
      \s+
      (\d*[.])?\d+(in|cm|mm)$
    }x

    attr_reader :pattern

    def initialize value, dpi
      if value == :solid
        @pattern = nil
      elsif value == :dotted
        @pattern = [
          Args::UnitConversion.parse('0.2mm', dpi),
          Args::UnitConversion.parse('0.5mm', dpi)
        ]
      elsif value == :dashed
        @pattern = [
          Args::UnitConversion.parse('2mm', dpi),
          Args::UnitConversion.parse('2mm', dpi)
        ]
      elsif value.is_a? String
        @pattern = value.split(' ').map{
          |val| Args::UnitConversion.parse val, dpi}
      else
        raise ArgumentError, 'Unsupported dash style'
      end
    end
  end


  class Template
    include Args::ColorValidator

    # Defaults are set for poker sized deck on a A4 sheet, with no cards
    DEFAULTS = {
      'sheet_width' => '210mm',
      'sheet_height' => '297mm',
      'card_width' => '63mm',
      'card_height' => '88mm',
      'dpi' => 300,
      'position_reference' => :topleft,
      'crop_line' => {
        'style' => :solid,
        'width' => '0.02mm',
        'color' => :black,
        'overlay' => :on_margin,
        'lines' => []
      },
      'cards' => []
    }

    attr_reader :dpi

    def initialize(template_hash = DEFAULTS, dpi)
      ClassyHash.validate(template_hash, SCHEMA)
      @template_hash = template_hash
      @dpi = dpi
      @crop_line_default = @template_hash['crop_line'].select {
        |k, v| ["style", "width", "color"].include? k}
    end

    # Load the template definition file
    def self.load(file, dpi)
      yaml = {}
      thefile = File.exist?(file) ? file: builtin(file)
      if File.exists? thefile
        yaml = YAML.load_file(thefile) || {}
      end

      # Bake the default values into our template
      new_hash = DEFAULTS.merge(yaml)
      new_hash['crop_line'] = DEFAULTS['crop_line'].merge(
        new_hash['crop_line'])

      # Create a new template file
      warn_unrecognized(yaml)
      Template.new new_hash, dpi
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

    def crop_line_overlay
      @template_hash['crop_line']['overlay']
    end

    def crop_lines
      lines = @template_hash['crop_line']['lines'].map(
        &method(:parse_crop_line))
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
      parsed_cards = cards
      crop_line_width = 2 * Args::UnitConversion.parse(
        @template_hash['crop_line']['width'], @dpi)
      left, right = parsed_cards.minmax { |a, b| a['x'] <=> b['x'] }
      top, bottom = parsed_cards.minmax { |a, b| a['y'] <=> b['y'] }

      {
        left: left['x'] - crop_line_width,
        right: right['x'] + card_width + crop_line_width,
        top: top['y'] - crop_line_width,
        bottom: bottom['y'] + card_height + crop_line_width
      }
    end

    private

    # Template file schema
    UNIT_REGEX = /^(\d*[.])?\d+(in|cm|mm)$/
    SCHEMA = {
      "sheet_width" => UNIT_REGEX,
      "sheet_height" => UNIT_REGEX,
      "card_width" => UNIT_REGEX,
      "card_height" => UNIT_REGEX,
      "position_reference" => ClassyHash::G.enum(:topleft, :center),
      "crop_line" => {
        "style" => [
          ClassyHash::G.enum(:solid, :dotted, :dashed),
          CropLineDash::VALIDATION_REGEX
        ],
        "width" => UNIT_REGEX,
        "color" => [ String, Symbol ],
        "overlay" => ClassyHash::G.enum(
          :on_margin, :overlay_on_cards, :beneath_cards),
        "lines" => [[{
          "type" => ClassyHash::G.enum(:horizontal, :vertical),
          "position" => UNIT_REGEX,
          "style" => [
            :optional, ClassyHash::G.enum(:solid, :dotted, :dashed)],
          "width" => [:optional, UNIT_REGEX],
          "color" => [:optional, String, Symbol],
        }]]
      },
      "cards" => [[{ "x" => UNIT_REGEX, "y" => UNIT_REGEX }]]
    }

    # Return path for built-in sheet templates
    def builtin(file)
      "#{File.dirname(__FILE__)}/sheet_templates/#{file}"
    end

    # Warn unrecognized options in the template sheet
    def self.warn_unrecognized(yaml)
      unrec = yaml.keys - DEFAULTS.keys
      if unrec.any?
        Squib::logger.warn(
          "Unrecognized configuration option(s): #{unrec.join(',')}")
      end
    end

    # Parse crop line definitions from template.
    def parse_crop_line(line)
      new_line = @crop_line_default.merge line
      new_line['width'] = Args::UnitConversion.parse(new_line['width'], @dpi)
      new_line['color'] = colorify new_line['color']
      new_line['style'] = CropLineDash.new(new_line['style'], @dpi)
      new_line['line'] = CropLine.new(
        new_line['type'], new_line['position'], sheet_width, sheet_height,
        @dpi)
      new_line
    end

    # Parse card definitions from template.
    def parse_card(card)
      new_card = card.rehash

      x = Args::UnitConversion.parse(card["x"], @dpi)
      y = Args::UnitConversion.parse(card["y"], @dpi)
      if @template_hash["position_reference"] == :center
        # Normalize it to a top-left positional reference
        x = x - card_width / 2
        y = y - card_width / 2
      end

      new_card["x"] = x
      new_card["y"] = y
      new_card
    end
  end


  class CropLine
    attr_reader :x1, :y1, :x2, :y2

    def initialize(type, position, sheet_width, sheet_height, dpi)
      method = "parse_#{type}"
      send method, position, sheet_width, sheet_height, dpi
    end

    def parse_horizontal(position, sheet_width, sheet_height, dpi)
      position = Args::UnitConversion.parse(position, dpi)
      @x1 = 0
      @y1 = position
      @x2 = sheet_width
      @y2 = position
    end

    def parse_vertical(position, sheet_width, sheet_height, dpi)
      position = Args::UnitConversion.parse(position, dpi)
      @x1 = position
      @y1 = 0
      @x2 = position
      @y2 = sheet_height
    end
  end
end
